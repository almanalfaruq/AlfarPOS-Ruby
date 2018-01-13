#= require jquery_ujs
#= require jquery-ui/widgets/autocomplete
#= require autocomplete-rails

# Define the variables
total = 0
itemsCode = []
itemsQty = []
tdeditable = null
print = false
refresh = false
pay = 0

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
		addTotal()
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

printPdf = (orderId) ->
	qz.websocket.connect().then(() ->
		return qz.printers.find("TM")
	).then((printer) ->
		config = qz.configs.create(printer, { size: {width: 76, height: 297 }, units: 'mm', scaleContent: 'false', rasterize: 'false' })
		data = [{ type: 'pdf', data: '/orders/' + orderId + '.pdf'}]
		return qz.print(config, data)
		).then(() ->
			if (refresh)
				refresh = false
				window.location.reload()
			).catch((e) ->
				console.error(e)
				)

# Send post method to create the order detail per item
createOrderDetail = (orderId, items, qty) ->
	$.post "/order_details/new.json",
			order_id: orderId
			items: items
			qtys: qty
			cash: pay
			(data, status) ->
				if (status == "success")
					if (print)
						print = false
						printPdf(orderId)
					else
						window.location.reload()
				else
					alert "Harap refresh halaman"

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
	cash = $("#cash-payed").val()
	$.post "/orders/new.json",
		order_id: orderId
		(data, status) ->
			if (status == "success")
				refresh = true
				createOrderDetail(orderId, itemsCode, itemsQty)
			else
				alert "Harap refresh halaman"

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
			body = "<h1 id='total-modal' class='text-center'></h1><form class='form-group'> <label for='recipient-name' class='col-form-label'>Total Bayar:</label><input type='text' class='form-control' id='cash-payed'></form><label class='col-form-label'>Total Kembali:</label><h4 id='cash-returned' class='text-right'>Rp 0,00</h4>"
			footer = "<button type='button' class='btn btn-secondary' data-dismiss='modal'>Batal</button> <button id='finish-order' type='button' class='btn btn-warning'>Ya</button> <button id='finish-print' type='button' class='btn btn-success cetak'>Ya dan Cetak</button>"
		when "print"
			title = "Cetak Transaksi"
			body = "Apakah transaksi akan dicetak?"
			footer = "<button type='button' class='btn btn-secondary' data-dismiss='modal'>Batal</button> <button type='button' class='btn btn-success cetak' id='btn-cetak'>Cetak</button>"
		else
			console.log "Nothing clicked"
	$(".modal-title").html(title)
	$(".modal-body").html(body)
	$(".modal-footer").html(footer)
)

# What going to do when modal was shown
$(".modal").on("shown.bs.modal", () ->
	returned = Number($("#cash-payed").val()) - total
	if (returned <= 0)
		$("#finish-order").prop("disabled", true)
		$("#finish-print").prop("disabled", true)
	$("#total-modal").text("Rp " + total + ",00")
	$("#cash-payed").focus()
	$("#cash-payed").keyup((e) ->
		returned = Number($(this).val()) - total
		console.log(returned)
		if ($(this).val() == 0 || $(this).val() == "" || returned < 0 || returned == null || total == 0)
			$("#finish-order").prop("disabled", true)
			$("#finish-print").prop("disabled", true)
		else if (returned > 0)
			$("#finish-order").prop("disabled", false)
			$("#finish-print").prop("disabled", false)
		$("#cash-returned").text("Rp " + returned + ",00")
	)
	$("#cash-payed").keydown((e) ->
		if (e.which == 13 && returned >= 0)
			pay = $(this).val()
			$("#finish-print").click()
			$(".modal").modal("hide")
			e.preventDefault()
	)
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
		print = true
		finishTranscation()
		$(".modal").modal("hide")
	)
	$("#btn-cetak").click(() ->
		printPdf("3908D387-6383-4920-800A-FB873ABFAEC0")
	)
)

