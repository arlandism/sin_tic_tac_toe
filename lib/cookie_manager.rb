class CookieManager

  def initialize(request,response)
    @request = request
    @response = response
  end

  def set_cookie(key,val)
    @response.set_cookie(key,val)
  end

  def clear_cookies
    @request.cookies.keys.each do |key|
      @response.delete_cookie(key)
    end
  end

end
