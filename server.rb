require 'sinatra'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

get '/' do
  db_connection do |connection|
    @recipes = connection.exec("SELECT name, id FROM recipes ORDER BY name")
  end

  erb :recipes
end


get '/recipes/:id' do
  @id = params[:id]
  db_connection do |connection|
    @ingredients = connection.exec_params("SELECT name FROM ingredients
    WHERE recipe_id = $1", [@id])
    @info = connection.exec_params("SELECT name, instructions, description
    FROM recipes WHERE id = $1", [@id])

  end
  erb :recipe_view
end
