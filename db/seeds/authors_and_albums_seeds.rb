require 'open-uri'

# 1. Incluir el helper para que 'fixture_file_upload' esté disponible
include ActionDispatch::TestProcess

# 2. DEFINIR LA RUTA BASE para que 'fixture_file_upload' sepa dónde buscar.
# Esto asegura que el método 'file_fixture_path' sea accesible.
class Object
  # Asegura que el método se defina solo si no existe o si estamos en el contexto de seeds
  def file_fixture_path
    # Apunta a la carpeta donde guardaste tus archivos
    Rails.root.join('test', 'fixtures', 'files')
  end
end

puts "--- Ejecutando seeds para Disquera (Versión Final) ---"
# ... el resto de tu código de seeds ...

# Importa el helper necesario para adjuntar archivos desde test/fixtures
include ActionDispatch::TestProcess

puts "--- Ejecutando seeds para Disquera ---"

# --- Limpieza de Datos ---
Author.destroy_all
Genre.destroy_all
Album.destroy_all
Audio.destroy_all
Image.destroy_all
puts "Modelos limpios (Authors, Genres, Albums, Audios, Images)."


# --- 1. Creación de Autores ---
puts "Creando autores..."
michael_jackson = Author.find_or_create_by!(full_name: "Michael Jackson")
acdc = Author.find_or_create_by!(full_name: "AC/DC")
nirvana = Author.find_or_create_by!(full_name: "Nirvana")


# --- 2. Creación de Géneros ---
puts "Creando géneros..."
pop = Genre.find_or_create_by!(name: "Pop")
rock_hard = Genre.find_or_create_by!(name: "Hard Rock")
grunge = Genre.find_or_create_by!(name: "Grunge")


# --- 3. Creación de Álbumes (con Media Type y Year) ---
puts "Creando álbumes y asociando media type..."

albums_data = [
  {
    name: "Thriller",
    author: michael_jackson,
    genre: pop,
    year: 1982,
    media_type: "Vinilo",
    unit_price: 45.00,
    stock_available: 500,
    description: "El álbum más vendido de todos los tiempos.",
    track_count: 9,
    condition_is_new: false,
    cover_file: 'thriller_cover.jpg', # Archivo de portada SÍ existe
    audio_file: 'thriller_audio.mp3'# SÍ tiene canciones
  },
  {
    name: "Back in Black",
    author: acdc,
    genre: rock_hard,
    year: 1980,
    media_type: "CD",
    unit_price: 30.00,
    stock_available: 300,
    description: "Un tributo al ex vocalista Bon Scott.",
    track_count: 10,
    condition_is_new: false,
    cover_file: 'backinblack_cover.png', # Archivo de portada SÍ existe
    audio_file: nil# NO tiene canciones
  },
  {
    name: "Nevermind",
    author: nirvana,
    genre: grunge,
    year: 1991,
    media_type: "CD",
    unit_price: 35.00,
    stock_available: 400,
    condition_is_new: true,
    description: "Álbum que popularizó el rock alternativo.",
    track_count: 12,
    cover_file: nil, # NO tiene archivo de portada
    audio_file: nil # NO tiene canciones
  }
]

# -----------------------------------------------------------
# CREACIÓN E ITERACIÓN CON LÓGICA CONDICIONAL
# -----------------------------------------------------------

albums_data.each do |data|
  album_attributes = data.slice(:name, :author, :genre, :year, :media_type, :unit_price, :stock_available, :condition_is_new, :description)
  album = Album.create!(album_attributes)

  puts "  -> Creado Álbum: #{album.name}"

  # --- A. Adjuntar Imagen (Cover) ---
  if data[:cover_file]
    begin
      file_name = data[:cover_file]
      cover_file = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', file_name), 'image/jpeg')

      album.images.create!(
        title: "#{album.name} Cover",
        is_cover: true
      ) do |image|
        # Asumiendo que el modelo Image tiene attached :cover_image
        image.photo.attach(cover_file)
      end
      puts "    -> Adjuntada portada: #{file_name}"
    rescue StandardError => e
      puts "    -> ERROR al adjuntar imagen para #{album.name}. ¿Existe el archivo #{file_name} en test/fixtures/files/?"
      puts e
    end
  else
    puts "    -> Sin imagen de portada."
  end

  # --- B. Adjuntar Audio Único ---
  if data[:audio_file]
    begin
      audio_file_name = data[:audio_file]
      audio_file_upload = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', audio_file_name), 'audio/mp3')

      # Crea un único registro de Audio asociado al Álbum
      album.create_audio! do |audio|
          # Asumiendo que el modelo Audio tiene attached :track_file
          audio.clip.attach(
              io: audio_file_upload,
              filename: audio_file_name,
              content_type: 'audio/mp3'
          )
      end
      puts "    -> Adjuntado archivo de audio: #{audio_file_name}"
    rescue StandardError => e
      puts e
      puts "    -> ERROR al adjuntar Audio para #{album.name}: ¿Existe el archivo #{audio_file_name} en test/fixtures/files/?"
    end
  else
    puts "    -> No se adjuntó audio."
  end
end

puts "--- Seeds de Lanzamientos Musicales Finalizados ---"
