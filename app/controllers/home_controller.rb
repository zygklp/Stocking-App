class HomeController < ApplicationController
  def index
    FinnhubRuby.configure do |config|
			config.api_key['api_key'] = 'cnbh8q1r01qks5ivq0q0cnbh8q1r01qks5ivq0qg'
		end
		
		@api = FinnhubRuby::DefaultApi.new

  	if params[:ticker] == ""
  		@nothing = "Hey! You Forgot To Enter A Symbol"
  	elsif params[:ticker]
			@present = @api.company_profile2({symbol: params[:ticker]})
  		@stock = @api.quote(params[:ticker])
  		if !@present.name
  			@error = "Hey! That Stock Symbol Doesn't Exist. Please Try Again."
  		end
  	end

  end

  def about
  end

end
