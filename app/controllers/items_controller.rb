class ItemsController < ApplicationController
  # devise不使用時
  before_action :correct_item, only: [:show, :edit, :update, :destroy]

  # devise使用時
  # before_action :authenticate_user!, except: [:show, :index, :search]
  # before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:success] = "Item created!"
      redirect_to item_path(@item)
    else
      flash[:danger] = "Failed to create item"
      render 'items/new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:item][:delete_img_ids].present?
      params[:item][:delete_img_ids].each do |id|
        @item.imgs.find_by_id(id)&.delete
      end
    end
    if params[:item][:imgs].present?
      params[:item][:imgs].each do |img|
        @item.imgs.attach(img)
      end
    end
    if @item.update(item_params)
      flash[:success] = "Item edited!"
      redirect_to item_path(@item)
    else
      flash[:danger] = "Failed to edit item"
      render 'items/edit', status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    flash[:success] = "Item deleted"
    redirect_to root_path
  end

  def index
    @items = Item.all
  end

  def show
    # @item = Item.find(params[:id])  devise使用時は有効化
  end

  def search
    @items = Item.search(params)
  end

  private
    def correct_item
      @item = Item.find(params[:id])
    end

    def correct_user
      @item = current_user.items.find_by(id: params[:id])
      redirect_to item_path(Item.find(params[:id])) if @item.nil?
    end

    def item_params
      params.require(:item).permit(:name, :description, :price)
    end
end
