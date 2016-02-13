current_folder = File.expand_path('../', __FILE__)
Dir[
    "#{current_folder}/**/**/*.rb",
    "#{current_folder}/**/*.rb"
].each { |f| require f }