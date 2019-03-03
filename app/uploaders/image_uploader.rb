class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
 
  # S3にアップロードする場合
  if Rails.env.production? || Rails.env.staging?
    storage :fog
  else
    storage :file
  end

  process convert: 'jpg'

  # 保存ディレクトリ名
  def store_dir
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "user_images/#{model.id}"
  end
 
  # デフォルト画像リサイズ
  process :resize_to_limit => [700, 700]
 
  # サムネイル画像リサイズ
  version :thumb do
     process resize_to_fill: [100, 100]
  end
 
  # 許可する画像の拡張子
  def extension_whitelist
     %w(jpg jpeg gif png)
  end
 
  # 保存するファイル名
  def filename
     "#{model.id}.jpg" if original_filename
  end
 
  protected
  # 一意となるトークンを作成
  def secure_token
     var = :"@#{mounted_as}_secure_token"
     model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
