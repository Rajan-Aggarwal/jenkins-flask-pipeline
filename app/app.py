from flask import Flask, jsonify

# A simple REST service returning a json

app = Flask(__name__)

json = [
	{
	'id': 1,
	'title': 'Jenkins pipeline for python-flask',
	}
]

@app.route('/', methods=['GET'])
def get_tasks():
	return jsonify({'json': json})

if __name__ == '__main__':
	app.run(host='0.0.0.0')