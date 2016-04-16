require 'json'

def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	$report_file = File.new("report.txt", "w+")
end

def start
	setup_files
	generate_report
end

def generate_report
	$report_file.puts report_header # Print "Sales Report" in ascii art 
	$report_file.puts(Time.now.strftime("%D")) # Print today's date
	$report_file.puts products_header # Print "Products" in ascii art
	products_section
	$report_file.puts brands_header # Print "Brands" in ascii art
	global_brands_data
	analyze_collect_brands_data
	print_all_brands_data

end

def line_separator(line_length = 40)
	return "*" * line_length
end

def new_line
	puts "\n"
end

def average(sales_price)
	average = sales_price / 2
	return "Average Sales Price: $#{average}"
end

def discount(discount1, discount2)
	average_discount = (discount1 - discount2) / discount1 * 100
	return "Average Discount: #{average_discount.round(2)}%"
end

def avg_brand_price(brand_price1, brand_price2)
	average_brand_price = brand_price1 / brand_price2
	return "Average Price: $#{average_brand_price.round(2)}"
end

def average_lego_brand_price(sales_price)
	average = sales_price / 2
	return "Average Price: $#{average.round(2)}"
end

def average_nano_brand_price(sales_price)
	average = sales_price / 1
	return "Average Price: $#{average.round(2)}"
end

def report_header
" ####                                  #####
#     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####
#        #  #  #      #      #         #     # #      #    # #    # #    #   #
 #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   #
      # ###### #      #           #    #   #   #      #####  #    # #####    #
#     # #    # #      #      #    #    #    #  #      #      #    # #   #    #
 #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   #
********************************************************************************"
  
end

def products_header
"                     _            _
                    | |          | |
 _ __  _ __ ___   __| |_   _  ___| |_ ___
| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|
| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\
| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/
| |
|_|                                       "
end

def brands_header
" _                         _
| |                       | |
| |__  _ __ __ _ _ __   __| |___
| '_ \\| '__/ _` | '_ \\ / _` / __|
| |_) | | | (_| | | | | (_| \\__ \\
|_.__/|_|  \\__,_|_| |_|\\__,_|___/
                                   "
end

def products_section
	$products_hash["items"].each do |toy|
		$report_file.puts toy["title"]
		$report_file.puts(line_separator)
		retail_price = toy["full-price"].to_f
		$report_file.puts "Retail Price: $#{toy["full-price"]}"
		$report_file.puts "Total Purchases: #{toy["purchases"].count}"
		
		
	end
end

def total_sales(toy)
    total_sales = toy["purchases"][0]["price"].to_f + toy["purchases"][1]["price"].to_f
    $report_file.puts "Total Sales: #{total_sales}"
    average_price = total_sales / 2
		$report_file.puts average(total_sales)
		$report_file.puts discount(retail_price, average_price)
		$report_file.puts(new_line)
end  

def global_brands_data
	$lego = {brand: "",count: 0, price_sum: 0, sales: 0, revenue: 0}
	$nano_block = {brand: "",count: 0, price_sum: 0, sales: 0, revenue: 0}
end

def analyze_collect_brands_data
	brand_lego_data
	brand_nano_data
end

def brand_lego_data
	$products_hash["items"].each do |brand|
		if brand["brand"] == "LEGO"
			$lego[:brand] = brand["brand"] 
			$lego[:count] += brand["stock"] 
			$lego[:price_sum] += brand["full-price"].to_f
			$lego[:revenue] += brand["purchases"][0]["price"].to_f + brand["purchases"][1]["price"].to_f
		end
	end
end

def brand_nano_data
	$products_hash["items"].each do |brand|
		if brand["brand"] == "Nano Blocks"
			$nano_block[:brand] = brand["brand"]
			$nano_block[:count] += brand["stock"]
			$nano_block[:price_sum] += brand["full-price"].to_f
			$nano_block[:revenue] +=  brand["purchases"][0]["price"] + brand["purchases"][1]["price"].to_f
			$nano_block[:sales] += brand["purchases"].count
		end
	end
end

def print_all_brands_data
	print_lego_brand_data
	$report_file.puts(new_line)
	print_nano_brand
end

def print_lego_brand_data
	$report_file.puts($lego[:brand])
	$report_file.puts(line_separator)
	$report_file.puts("Total Inventory: #{$lego[:count]}")
	$report_file.puts(average_lego_brand_price($lego[:price_sum]))
	$report_file.puts("Total Revenue: $#{$lego[:revenue].round(2)}")
end

def print_nano_brand
	$report_file.puts($nano_block[:brand])
	$report_file.puts(line_separator)
	$report_file.puts("Total Inventory: #{$nano_block[:count]}")
	$report_file.puts(average_nano_brand_price($nano_block[:price_sum]))
	$report_file.puts("Total Revenue: $#{$nano_block[:revenue]}")
end

start