#= require jquery_ujs
#= require jquery-ui/widgets/autocomplete
#= require autocomplete-rails

# Define the variables
total = 0
itemsCode = []
itemsQty = []
tdeditable = null

# Setting up the date
setDate = () ->
	today = new Date()
	day = today.getDate()
	if (day<10) then day="0"+day
	month = today.getMonth()+1
	if (month<10) then month="0"+month
	year = today.getFullYear()
	today = year+"-"+month+"-"+day

$("#date").val(setDate())

# Add total function
addTotal = () ->
	total = 0
	$("td.subtotal").each((i, obj) -> 
		subtotal = Number($(this).text().split(" ")[1]) # convert text in subtotal column to number
		total += subtotal; # add it to total
	)
	$("#total").html("Rp " + total); # append to the view

addTotal()

insertToTable = (code) ->
	rows = $("#items tbody tr").length+1 # counting table body rows
	# get json code from the link below
	$.getJSON("items/"+code+".json",(data) ->
		row = "<tr><th scope='row'>"+rows+"</th><td class='code'>"+data["code"]+"</td><td>"+data["name"]+"</td><td hidden>"+data["price"]+"</td><td class='qty' contenteditable>1</td><td class='subtotal'>Rp "+data["price"]+"</td><td><a href='#' class='del-row' style='color:red;'><span class='fa fa-close'></span></a></td></tr>"
		$("table tbody").append(row) # adding row after last row
		addTotal(); 	
		$("#item").val("") # clear the text box
		tdeditable = $("#items tbody tr:last-child td.qty")
		rowOptions()
	)

# Saving input when qty was edited
save = (input) ->
	price = input.closest("tr").find("td:hidden").text()
	price = Number(price)
	subs = Number(input.text())*price
	input.closest("tr").find("td.subtotal").text("Rp "+subs)
	addTotal()

# Some row options that refresh everytime new item added
rowOptions = () -> 
	# Prevent enter default when editing qty column
	$("td[contenteditable]").on("keypress", (e) ->
		keycode = e.charCode || e.keyCode
		if (keycode == 13)
			$(this).blur()
			save($(this))
			$("#item").focus()
			return false
		)
	# Delete row if 'x' was clicked
	$("a.del-row").click((e) ->
		$(this).closest("tr").remove()
		addTotal()
		tdeditable = $("#items tbody tr:last-child td.qty") # Get the latest table row child
		e.preventDefault()
		)

# Send post method to create the order detail per item
createOrderDetail = (orderId, items, qty) ->
	$.post "/order_details/new.json", 
			order_id: orderId
			items: items
			qtys: qty
			(data, status) ->
				if (status == "success") then window.location.reload() else alert "Harap refresh halaman"

# Get all items code and qty that buyer buy
getCodesQty = () ->
	$("td.code").each((i, obj) ->
		itemsCode.push($(this).text())
		)
	$("td.qty").each((i, obj) ->
		itemsQty.push($(this).text())
		)

# Send post method to create the order first then invoke create order detail method
finishTranscation = () ->
	getCodesQty()
	orderId = $("#sellid").val()
	$.post "/orders/new.json",
		order_id: orderId 
		(data, status) ->
			if (status == "success") then createOrderDetail(orderId, itemsCode, itemsQty) else alert "Harap refresh halaman"

# If has enter pressed on barcode text box
$("#item").keydown((e) ->
	code = $("#item").val() # get text from text box
	if (e.which == 13 && !isNaN(code.charAt(0)) && code != "") # 13 is enter key code
		insertToTable(code)
	else if (e.which == 13 && e.ctrlKey)
		$("#btn-finish").click()
	else if (e.which == 39 && e.ctrlKey) # 39 is right arrow key code
		tdeditable.trigger("focus")
	else if (e.which == 46 && e.ctrlKey) # 46 is delete key code
		tdeditable.closest("tr").remove()
		addTotal()
	tdeditable = $("#items tbody tr:last-child td.qty") # Get the latest table row child
	)

# Prevent default enter on autocomplete form
$("#form-code").submit((e) ->
	e.preventDefault()
	)

# Binding selected item on rails autocomplete
$("#item").bind('railsAutocomplete.select', (e,d) ->
	code = d.item.code # get text from text box
	insertToTable(code)
	)

# What to do when modal is going to show
$(".modal").on("show.bs.modal", (e) ->
	title = ""
	body = ""
	footer = ""
	dataTarget = $(e.relatedTarget).data("btn")
	modal = $(this)
	# Switch for the modal content
	switch dataTarget
		when "new"
			title = "Transaksi Baru"
			body = "Apakah anda ingin membuat transaksi baru?"
			footer = "<button type='button' class='btn btn-secondary' data-dismiss='modal'>Batal</button><button id='new-order' type='button' class='btn btn-primary'>Transaksi baru</button>"
		when "clear"
			title = "Hapus Transaksi"
			body = "Hapus transaksi ini?"
			footer = "<button type='button' class='btn btn-secondary' data-dismiss='modal'>Batal</button><button id='clear-order' type='button' class='btn btn-danger'>Hapus transaksi</button>"
		when "finish"
			title = "Selesai Transaksi"
			body = "Apakah transaksi sudah selesai?" 
			footer = "<button type='button' class='btn btn-secondary' data-dismiss='modal'>Batal</button> <button id='finish-order' type='button' class='btn btn-warning'>Ya</button> <button id='finish-print' type='button' class='btn btn-success cetak'>Ya dan Cetak</button>"
		when "print"
			title = "Cetak Transaksi"
			body = "Apakah transaksi akan dicetak?" 
			footer = "<button type='button' class='btn btn-secondary' data-dismiss='modal'>Batal</button> <button type='button' class='btn btn-success cetak'>Cetak</button>"
		else
			console.log "Nothing clicked"
	$(".modal-title").html(title)
	$(".modal-body").html(body)
	$(".modal-footer").html(footer)
	)

# What going to do when modal was shown
$(".modal").on("shown.bs.modal", () ->
	# Refresh if new order was clicked
	$("#new-order").click(() ->
		window.location.reload()
		)
	# Clear the table but not refreshing the page
	$("#clear-order").click(() ->
		$("table tbody").empty()
		$(".modal").modal("hide")
		addTotal()
		)
	$("#finish-order").click(() ->
		finishTranscation()
		)
	$("#finish-print").click(() ->
		finishTranscation()
		)
	# Focus on print button
	$(".cetak").focus()
	$(".cetak").click(() ->
		$(".modal").modal("hide")
		)
	)

