puts "--- Creando Ventas de Prueba ---"

manager_user = User.find_by(email: MANAGER_EMAIL)

if manager_user.nil?
  raise "No existe el manager_user. Verifica que MANAGER_EMAIL esté bien configurado."
end

albums = Album.limit(3)

if albums.count < 3
  raise "Se necesitan al menos 3 álbumes para generar las ventas de prueba."
end

ventas_data = [
  {
    buyer_name: "Juan Pérez",
    buyer_id: "34567890",
    buyer_contact: "juan@example.com",
    items: [
      { album: albums[0], quantity: 1 },
      { album: albums[1], quantity: 2 }
    ]
  },
  {
    buyer_name: "María López",
    buyer_id: "28765432",
    buyer_contact: "1144556677",
    items: [
      { album: albums[1], quantity: 1 }
    ]
  },
  {
    buyer_name: "Carlos Díaz",
    buyer_id: "32999888",
    buyer_contact: nil,
    items: [
      { album: albums[2], quantity: 3 }
    ]
  }
]

ventas_data.each do |data|
  total = data[:items].sum { |i| i[:album].unit_price * i[:quantity] }

  sale = Sale.new(
    buyer_name: data[:buyer_name],
    buyer_id: data[:buyer_id],
    buyer_contact: data[:buyer_contact],
    total: total,
    sale_date: Time.zone.now,
    user: manager_user
  )

  data[:items].each do |item|
    sale.sale_items.build(
      album: item[:album],
      quantity: item[:quantity],
      product_name: item[:album].name,
      price: item[:album].unit_price
    )
  end

  sale.save!

  data[:items].each do |item|
    item[:album].update!(
      stock_available: item[:album].stock_available - item[:quantity]
    )
  end

  puts "  -> Venta creada: #{sale.id} (Total: $#{total})"
end

puts "--- Ventas creadas correctamente ---"
