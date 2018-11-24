def update_quality(items)
  items.each do |item|
	updateter = ItemUpdaterFactory.getUpdater(item.name)
	item = updateter.updateItem(item)
  end
end

class ItemUpdaterFactory
	def self.getUpdater(name)		
		case name.downcase
		when "aged brie"
			AgedBrieUpdater.new
		when "backstage passes"
			BackstagePassesUpdater.new
		when "sulfuras"
			SulfurasUpdater.new
		when "conjured"
			ConjuredUpdater.new
		else
			NormalUpdater.new
		end
	end
end

class  NormalUpdater
	def updateItem(item)
		updated_item = update_sell_in(item)
		updated_item = update_quality(item)
		updated_item
	end
	
	def update_sell_in(item)
		item.sell_in += get_sell_in_loss
	end
	
	def update_quality(item)
		item.quality += (get_quality_loss(item) * get_quality_loss_multiplier(item)) if item.quality > 0 
		normalize_item(item)
	end
	
	def normalize_item(item)
		item.quality = 0 if item.quality < 0 
		item.quality = getQualityMax if item.quality > getQualityMax
		item
	end
	
	# def get_modified_quality(current_quality)
		# current_quality + get_quality_loss > getQualityMax
	# end
	
	def get_sell_in_loss
		-1
	end
	
	def get_quality_loss(item=nil)
		-1
	end
	
	def get_quality_loss_multiplier(item)
		isExpired(item) ? 2 : 1
	end
	
	def isExpired(item)
		item.sell_in < 0
	end
	
	# def isPerfectQuality(item)
		# item.quality >= getQualityMax
	# end
	
	def getQualityMax
		50
	end
end

class  AgedBrieUpdater < NormalUpdater
	
	def get_quality_loss(item=nil)
		1
	end
end

class  BackstagePassesUpdater < AgedBrieUpdater
	
	def get_quality_loss(item=nil)
		quality_loss = super.get_quality_loss
		quality_loss += 1 if item.quality <= 10
		quality_loss += 1 if item.quality <= 5
		quality_loss = (- item.quality) if item.sell_in < 0
	end
	
end

class  SulfurasUpdater < NormalUpdater
	
	def updateItem(item)
		item
	end
end

class  ConjuredUpdater < NormalUpdater
	
	def get_quality_loss_multiplier(item)
		qLoss = super * 2
		qLoss
	end
end
######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
