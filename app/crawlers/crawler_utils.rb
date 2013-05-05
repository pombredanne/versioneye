class CrawlerUtils

  def self.create_newest product, version_number
    newest = Newest.new 
    newest.name = product.name 
    newest.prod_key = product.prod_key 
    newest.prod_type = product.prod_type
    newest.product_id = product._id.to_s
    newest.version = version_number
    newest.save
  end

  def self.create_notifications product, version_number
    followers = product.get_followers
    if followers && !followers.empty?
      followers.each do |follower|
        notification = Notification.new
        notification.user_id = follower.user_id 
        notification.product_id = follower.product_id
        notification.version_id = version_number
        notification.save 
      end
    end
  end

end