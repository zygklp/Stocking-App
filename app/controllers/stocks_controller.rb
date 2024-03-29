class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :set_api

  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
    @error = false
    begin
      @ticker_company = @api.company_profile2({symbol:@stock.ticker})
      @ticker = @api.quote(@stock.ticker)
    rescue
      @error = true
    end

  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(stock_params)
    save_check = (@stock.save) ? true : false
    error = false
    begin
      ticker_company = @api.company_profile2({symbol:@stock.ticker})
    rescue
      error = true
    end
    respond_to do |format|
      if !error and ticker_company.name.present? and save_check
        format.html { redirect_to @stock, notice: 'Stock was successfully created.' }
        format.json { render :show, status: :created, location: @stock }
      else
        @stock.destroy
        flash.now[:error] = "Stock was not created. Check your input!"
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    save_check = (@stock.update(stock_params)) ? true : false
    error = false
    begin
      ticker_company = @api.company_profile2({symbol:@stock.ticker})
    rescue
      error = true
    end

    respond_to do |format|
      if !error and ticker_company.name.present? and save_check
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        flash.now[:error] = "Stock was not updated. Check your input!"
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def correct_user
    @ticker = current_user.stocks.find_by(id: params[:id])
    redirect_to stocks_path, notice: "Not Authorized to edit this stock" if @ticker.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end
    def set_api
      @api = FinnhubRuby::DefaultApi.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:ticker, :user_id)
    end
end
