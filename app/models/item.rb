class Item < ApplicationRecord
  has_many_attached :imgs

  def update(params)
    params[:delete_img_ids]&.each {|id| imgs.find_by_id(id)&.delete }
    params[:imgs]&.each {|img| imgs.attach(img) }
    super params.except(:imgs, :delete_img_ids)
  end
end
