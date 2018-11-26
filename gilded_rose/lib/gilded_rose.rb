def update_quality(items)
  items.each do |item|
	updateter = ItemUpdaterFactory.getUpdater(item.name)
	item = updateter.updateItem(item)
  end
end

# Factory Class
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
		item.sell_in += get_sell_in_degrade
	end
	
	def update_quality(item)
		item.quality += (get_quality_degrade(item) * get_quality_degrade_multiplier(item)) 
		normalize_item(item)
	end
	
	def normalize_item(item)
		item.quality = 0 if item.quality < 0 
		item.quality = getQualityMax if item.quality > getQualityMax
		item
	end
	
	def get_sell_in_degrade
		-1
	end
	
	def get_quality_degrade(item=nil)
		-1
	end
	
	def get_quality_degrade_multiplier(item)
		isExpired(item) ? 2 : 1
	end
	
	def isExpired(item)
		item.sell_in < 0
	end
	
	def getQualityMax
		50
	end
end

class  AgedBrieUpdater < NormalUpdater
	
	def get_quality_degrade(item=nil)
		1
	end
	
	def get_quality_degrade_multiplier(item)
		1
	end
end

class  BackstagePassesUpdater < AgedBrieUpdater
	
	def get_quality_degrade(item=nil)
		quality_loss = super
		quality_loss += 1 if item.sell_in < 10
		quality_loss += 1 if item.sell_in < 5
		quality_loss = (- item.quality) if item.sell_in < 0
		quality_loss
	end
	
end

class  SulfurasUpdater < NormalUpdater
	
	def updateItem(item)
		item
	end
end

class  ConjuredUpdater < NormalUpdater
	
	def get_quality_degrade_multiplier(item)
		qLoss = super * 2
		qLoss
	end
end
######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
