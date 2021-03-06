class My::AuctionsController < My::ApplicationController
  before_action :set_auction, only: [ :show, :edit, :update, :destroy ]

  def index
    @auctions = current_user.auctions.order(:deadline_date).page params[:page]
  end

  def new
    @auction = current_user.auctions.new
  end

  def show
    render :edit
  end

  def create
    @auction = current_user.auctions.new(auction_params)
    if @auction.save
      redirect_to my_auctions_path, notice: 'オークション出品登録しました。'
    else
      redirect_to my_auctions_path, alert: 'オークション出品登録出来ませんでした。'
    end
  end

  def update
    if @auction.update(auction_params)
      redirect_to my_auctions_path, notice: 'オークション出品情報を更新しました。'
    else
      redirect_to my_auctions_path, alert: 'オークション出品情報を更新出来ませんでした。'
    end
  end

  def destroy
    if @auction.bids.empty?
      @auction.destroy
      redirect_to my_auctions_path, notice: 'オークション出品情報を削除しました。'
    else
      redirect_to my_auctions_path, alert: '既に入札されています。オークション出品情報を削除できません。'
    end
  end

  private

    def set_auction
      @auction = current_user.auctions.find(params[:id])
    end

    def auction_params
      params.require(:auction).permit(:name, :description, :deadline_date, :min_price, :product_id)
    end
end
