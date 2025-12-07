class Admin::SalesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :cancel, :invoice]

  def index
    @sales = Sale.all
  end

  def show
  end

  def new
    @sale = Sale.new
    @sale.sale_date ||= Time.current
  end

  def create
    @sale = Sale.new(sale_params)
    @sale.user = current_user
    @sale.sale_date = Time.current

    sale_items_params = params[:sale_items].to_a.select do |item|
      item[:quantity].present? && item[:quantity].to_i > 0
    end

    if sale_items_params.empty?
      flash[:alert] = "Debe seleccionar al menos un álbum con cantidad mayor a 0"
      return render :new, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      @sale.total = 0

      sale_items_params.each do |item|
        album = Album.find(item[:album_id])

        raise "No hay stock suficiente para #{album.name}" if album.stock_available < item[:quantity].to_i

        @sale.sale_items.build(
          album: album,
          quantity: item[:quantity].to_i,
          price: album.unit_price,
          product_name: album.name
        )

        album.update!(stock_available: album.stock_available - item[:quantity].to_i)

        @sale.total += (album.unit_price * item[:quantity].to_i)
      end

      @sale.save!
    end

    redirect_to admin_sales_path, notice: "Venta creada correctamente."
    rescue => e
      flash[:alert] = "No se pudo crear la venta: #{e.message}"
      render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    if @sale.update(sale_params)
      redirect_to admin_sales_path, notice: "Venta actualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sale.destroy
    redirect_to admin_sales_path, notice: "Venta eliminada."
  end

  def cancel
    if @sale.cancelled?
      redirect_to admin_sales_path, alert: "La venta ya está cancelada."
      return
    end

    ActiveRecord::Base.transaction do
      @sale.sale_items.each do |item|
        album = item.album
        album.update!(stock_available: album.stock_available + item.quantity)
      end

      @sale.update!(cancelled: true)
    end

    redirect_to admin_sales_path, notice: "Venta cancelada correctamente."
  end

  def invoice
    pdf = Prawn::Document.new(
      info: {
        Title: "Factura ##{@sale.id}"
      }
    )

    pdf.text "Factura ##{@sale.id}", size: 22, style: :bold
    pdf.move_down 20

    pdf.text "Fecha: #{(@sale.sale_date || Time.current).strftime('%d/%m/%Y %H:%M')}"
    pdf.text "Cliente: #{@sale.buyer_name}"
    pdf.text "Contacto: #{@sale.buyer_contact.presence || '-'}"
    pdf.move_down 20

    pdf.text "Detalle de Items", style: :bold
    pdf.move_down 10

    @sale.sale_items.each do |item|
      pdf.text "- #{item.product_name} (#{item.quantity})  $#{item.price}"
    end

    pdf.move_down 20
    pdf.text "Total: $#{@sale.total}", size: 16, style: :bold

    disposition = params[:download] == "true" ? "attachment" : "inline"

    send_data pdf.render,
      filename: "factura_#{@sale.id}.pdf",
      type: "application/pdf",
      disposition: disposition
  end


  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def sale_params
    params.require(:sale).permit(
      :buyer_id,
      :buyer_name,
      :buyer_contact,
      :cancelled,
      :user_id
    )
  end
end
