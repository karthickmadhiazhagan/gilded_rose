require_relative '../lib/gilded_rose'

describe "#update_quality" do

  context "with a single item" do
    let(:initial_sell_in) { 5 }
    let(:initial_quality) { 50 }
    let(:name) { "Noramal Item" }
    let(:item) { Item.new(name, initial_sell_in, initial_quality) }

    before { update_quality([item]) }
	context "when normal item" do
		it "quantity should not be greater than 50" do
		  expect(item.quality).to be <= 50
		end
		
		it "quantity should not be negative" do
		  expect(item.quality).to be > 0 
		end
	end
  end

  context "with multiple items" do
    let(:items) {
      [
		# Noraml Item
        Item.new("NORMAL ITEM", 5, 10),
		Item.new("NORMAL ITEM", 0, 15),
		Item.new("NORMAL ITEM", -1, 20),
        Item.new("NORMAL ITEM", 5, 0),
		Item.new("NORMAL ITEM", 0, 0),
		Item.new("NORMAL ITEM", -1, 0),
		# Aged Brie
        Item.new("Aged Brie", 48, 10),
        Item.new("Aged Brie", 0, 50),
        Item.new("Aged Brie", -1, 0),
		# Backstage Passes	
		# 10 days scenerio
        Item.new("Backstage Passes", 48, 9),
        Item.new("Backstage Passes", 11, 9),
        Item.new("Backstage Passes", 10, 9),
        Item.new("Backstage Passes", 10, 50),
        Item.new("Backstage Passes", 9, 50),
        Item.new("Backstage Passes", 9, 12),
		# 5 days scenerio
        Item.new("Backstage Passes", 6, 9),
        Item.new("Backstage Passes", 5, 9),
        Item.new("Backstage Passes", 5, 50),
        Item.new("Backstage Passes", 4, 50),
        Item.new("Backstage Passes", 4, 12),
		# 0 days scenerio
        Item.new("Backstage Passes", 1, 9),
        Item.new("Backstage Passes", 0, 9),
        Item.new("Backstage Passes", -1, 20),
        Item.new("Backstage Passes", 1, 50),
        Item.new("Backstage Passes", 0, 50),
		# Sulfuras
        Item.new("Sulfuras", nil, nil),
        Item.new("Sulfuras", nil, 80),
        Item.new("Sulfuras", 5, 55),
		# Conjured
        Item.new("Conjured", 5, 10),
		Item.new("Conjured", 0, 15),
		Item.new("Conjured", -1, 20),
        Item.new("Conjured", 5, 0),
		Item.new("Conjured", 0, 0),
		Item.new("Conjured", -1, 0)
      ]
    }
	
	let(:answers) { [
			# Noraml Item
			[4,9], [-1,13],[-2,18],
			[4,0],[-1,0],[-2,0],
			# Aged Brie
			[47,11],[-1,50],[-2, 1],
			# Backstage Passes #10	
			[47,10],[10,10],[9,11],
			[9,50 ],[8,50],[8,14],
			# 5 days	
			[5,11],[4,12],[4,50],
			[3,50 ],[3,15],
			#0 days
			[0,12],[-1,0],[-2,0],
			[0,50 ],[-1,0],
			# Sulfuras
			[nil,nil],[nil,80],[5, 55],
			# Conjured
			[4,8], [-1,11],[-2,16],
			[4,0],[-1,0],[-2,0]		
		] 
	}

    before { update_quality(items) }
	it "should pass all the senerios" do
		answers.each_with_index do |ans, index|
			expect(items[index].sell_in).to eq(ans[0])
			expect(items[index].quality).to eq(ans[1])
		end
		# expect(items[0].sell_in).to eq(4)
		# expect(items[0].quality).to eq(9)
		# expect(items[1].sell_in).to eq(-1)
		# expect(items[1].quality).to eq(13)
		# expect(items[2].sell_in).to eq(-2)
		# expect(items[2].quality).to eq(18)
		# expect(items[3].sell_in).to eq(4)
		# expect(items[3].quality).to eq(0)
		# expect(items[4].sell_in).to eq(-1)
		# expect(items[4].quality).to eq(0)
		# expect(items[5].sell_in).to eq(-2)
		# expect(items[5].quality).to eq(0)
	end
  end
end
