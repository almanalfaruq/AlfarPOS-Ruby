#= require jquery
#= require jquery_ujs
#= require jquery-ui/widgets/autocomplete
#= require autocomplete-rails

total = 0;

addTotal = () ->
	total = 0
	$("td.subtotal").each((i, obj) -> 
		subtotal = Number($(this).text().split(" ")[1]) # convert text in subtotal column to number
		if subtotal != null
			total += subtotal; # add it to total
		$("#total").html("Rp " + total); # append to the view
	);

addTotal();

# If has enter pressed on barcode text box
$("#item").keypress((e) ->
	code = $("#item").val() # get text from text box
	console.log(!isNaN(code.charAt(0)))
	if (e.which == 13 && !isNaN(code.charAt(0))) # 13 is enter key code
		rows = $("#items tbody tr").length+1 # counting table body rows
		# get json code from the link below
		$.getJSON("items/"+code+".json",(data) ->
			row = "<tr><th scope='row'>"+rows+"</th><td>"+data["code"]+"</td><td>"+data["name"]+"</td><td>1</td><td class='subtotal'>Rp "+data["price"]+"</td></tr>"
			$("table tbody").append(row) # adding row after last row
			addTotal(); 	
			$("#item").val("") # clear the text box
		)
);
$("#form-code").submit((e) ->
	e.preventDefault()
)
$("#item").bind('railsAutocomplete.select', (e,d) ->
	console.log(e)
	rows = $("#items tbody tr").length+1 # counting table body rows
	code = d.item.code # get text from text box
	# get json code from the link below
	$.getJSON("items/"+code+".json",(data) ->
		row = "<tr><th scope='row'>"+rows+"</th><td>"+data["code"]+"</td><td>"+data["name"]+"</td><td>1</td><td class='subtotal'>Rp "+data["price"]+"</td></tr>"
		$("table tbody").append(row) # adding row after last row
		addTotal(); 	
		$("#item").val("") # clear the text box
	)
);
