class PageController < ApplicationController

  def routing_error
    path = request.fullpath
    if path.match(/\/version\//)
      path.gsub!('/version/', '/')
    else
      path = '/'
    end
    redirect_to path
  end

  def legacy_route
    path = '/'
    key     = params[:key]
    version = params[:version]
    key = parse_param key
    if version
      version = parse_param version
    end
    product = Product.find_by_key key
    if product
      version = product.version if version.nil?
      path = "/#{product.language_esc}/#{product.to_param}/#{version}"
    else
      hash = fetch_lang_and_key( key )
      language = hash['language']
      key = hash['key']
      unless language.empty?
        product = Product.fetch_product language, key
        if product
          path = "/#{product.language_esc}/#{product.to_param}/#{version}"
        end
      end
    end
    redirect_to path.gsub('//', '/'), :status => 301
  end

  def legacy_badge_route
    path    = '/'
    key     = params[:key]
    version = params[:version]
    key     = parse_param key
    if version
      version = parse_param version
    end
    product = Product.find_by_key key
    if product
      version = product.version if version.nil?
      path    = "/#{product.language_esc}/#{product.to_param}/#{version}/badge.png"
    else
      hash     = fetch_lang_and_key( key )
      language = hash['language']
      key      = hash['key']
      unless language.empty?
        product = Product.fetch_product language, key
        if product
          path = "/#{product.language_esc}/#{product.to_param}/#{version}/badge.png"
        end
      end
    end
    redirect_to path.gsub('//', '/'), :status => 301
  end

  def show_visual_old
    key      = params[:key]
    version  = params[:version]
    prod_key = key.gsub(':', '/').gsub('~', '.').gsub('--', '/')
    product  = Product.find_by_key( prod_key )
    new_path = '/'
    if product
      new_path += "#{product.language_esc}/#{product.to_param}"
      if version
        new_path += "/#{version}"
      end
      new_path += '/visual_dependencies'
    end
    redirect_to new_path, :status => 301
  end

  def disclaimer
    redirect_to 'http://www.disclaimer.de/disclaimer.htm?farbe=FFFFFF/000000/000000/000000'
  end

  def contact
  end

  def faq
  end

  def documentation
  end

  def about
  end

  def impressum
  end

  def home
  end

  def terms
  end

  def enterprise_agreements
  end

  def signin
  end

  def signup
  end

  def apijson
  end

  def logos
  end

  def sitemap_1
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-1.xml'
  end
  def sitemap_2
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-2.xml'
  end
  def sitemap_3
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-3.xml'
  end
  def sitemap_4
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-4.xml'
  end
  def sitemap_5
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-5.xml'
  end
  def sitemap_6
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-6.xml'
  end
  def sitemap_7
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-7.xml'
  end
  def sitemap_8
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-8.xml'
  end
  def sitemap_9
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-9.xml'
  end
  def sitemap_10
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-10.xml'
  end
  def sitemap_11
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-11.xml'
  end
  def sitemap_12
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-12.xml'
  end
  def sitemap_13
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-13.xml'
  end
  def sitemap_14
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-14.xml'
  end
  def sitemap_15
    redirect_to 'https://s3.amazonaws.com/veye_assets/sitemap-15.xml'
  end

  private

    def parse_param key
      key.gsub("~", ".").gsub("--", "/").gsub(":", "/")
    end

    def fetch_lang_and_key( key )
      language = ""
      if key.match(/\Anpm\//)
        key = key.gsub("npm\/", "")
        language = Product::A_LANGUAGE_NODEJS
      elsif key.match(/\Apip\//)
        key = key.gsub("pip\/", "")
        language = Product::A_LANGUAGE_PYTHON
      elsif key.match(/\Aphp\//)
        key = key.gsub("php\/", "")
        language = Product::A_LANGUAGE_PHP
      end
      hash = Hash.new
      hash['key'] = key
      hash['language'] = language
      hash
    end

end
