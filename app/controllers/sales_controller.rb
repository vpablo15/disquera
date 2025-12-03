class SalesController < ApplicationController
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
    @sale = current_user.sales.new(sale_params)

    if @sale.save
      redirect_to sales_path, notice: "Venta creada correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @sale.update(sale_params)
      redirect_to sales_path, notice: "Venta actualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sale.destroy
    redirect_to sales_path, notice: "Venta eliminada."
  end

  def cancel
    if @sale.cancelled?
      redirect_to sales_path, alert: "La venta ya está cancelada."
    elsif @sale.update(cancelled: true)
      redirect_to sales_path, notice: "Venta cancelada correctamente."
    else
      redirect_to sales_path, alert: "No se pudo cancelar la venta."
    end
  end

  def invoice
    pdf = Prawn::Document.new

    pdf.text "Factura ##{@sale.id}", size: 22, style: :bold
    pdf.move_down 20

    pdf.text "Fecha: #{(@sale.sale_date || Time.current).strftime('%d/%m/%Y %H:%M')}"
    pdf.text "Cliente: #{@sale.buyer_name}"
    pdf.text "Contacto: #{@sale.buyer_contact.presence || '-'}"
    pdf.move_down 20

    pdf.text "Detalle de Items", style: :bold
    pdf.move_down 10

    # Si luego agregás sale_items, acá se agregan
    # @sale.sale_items.each do |item|
    #   pdf.text "- #{item.product_name} (#{item.quantity})  $#{item.price}"
    # end

    pdf.move_down 20
    pdf.text "Total: $#{@sale.total}", size: 16, style: :bold

    send_data pdf.render,
      filename: "factura_#{@sale.id}.pdf",
      type: "application/pdf",
      disposition: "inline"
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def sale_params
    params.require(:sale).permit(
      :sale_date,
      :buyer_name,
      :buyer_contact,
      :total,
      :cancelled
    )
  end
end
