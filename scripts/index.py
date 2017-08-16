from flask import Flask, request
from dominate.tags import *

app = Flask(__name__)

# Returns Hello World
@app.route('/test')
def index():
	return "Hello World!"

# Given JSON data in the form of [["bla", "bla"], ["bla", "blabla"]], renders it as a HTML table
# with the class of each <td> set as the item in the JSON.
@app.route('/render-square-grid', methods=['POST'])
def render_grid_endpoint():
	return render_grid(request.get_json(force=True))

def render_grid(grid):
	html_table = table(cls="square-grid", cellspacing=0)

	with html_table:
		for row in grid:
			with html_table.add(tr()): # Add a new row
				for item in row:
					td(cls=item) # Set the class to whatever was sent in in current position

	return html_table.render()

@app.route('/glider')
def glider():
	return render_grid([["off", "on", "off"], ["off", "off", "on"], ["on", "on", "on"]])

if __name__ == "__main__":
	app.run()