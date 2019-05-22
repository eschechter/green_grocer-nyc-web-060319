def consolidate_cart(cart)
  new_hash = {}
  cart.each do |item_hash|
    if !new_hash.keys.include?(item_hash.keys[0])
      item_key = item_hash.keys[0]
      new_hash[item_key] = item_hash.values[0]
      new_hash[item_key][:count] = cart.count(item_hash)
    end
  end
  return new_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    cur_key = coupon[:item]
    coupon_key = "#{cur_key} W/COUPON"
    if cart.keys.include?(coupon_key) && cart[cur_key][:count] >= coupon[:num]
      cart[cur_key][:count] -= coupon[:num]
      cart[coupon_key][:count] += 1
    elsif cart.keys.include?(coupon[:item]) && cart[cur_key][:count] >= coupon[:num]
      cart[cur_key][:count] -= coupon[:num]
      cart[coupon_key] = {price: coupon[:cost], clearance: cart[cur_key][:clearance], count: 1}
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item, item_hash|
    if item_hash[:clearance]
      item_hash[:price] = (item_hash[:price] *  0.8).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  
  tot = 0

  cart.each do |item, item_hash|
    tot += item_hash[:price] * item_hash[:count]
  end

  if tot > 100
    tot *= 0.9
  end
  return tot
end
