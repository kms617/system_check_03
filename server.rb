###########################################################################
# Acceptance Criteria:

# Visiting /recipes lists the names of all of the recipes in the database,
#    sorted alphabetically.
# Each name is a link that takes you to the recipe details page (e.g. /recipes/1)
# Visiting /recipes/:id will show the details for a recipe with the given ID.
# The page must include the recipe name, description, and instructions.
# The page must list the ingredients required for the recipe.
###########################################################################


require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'

###########################################################################
## METHODS
###########################################################################
def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

def get_all_recipes
  query= %Q{SELECT * FROM recipes ORDER BY name;}

  results = db_connection do |conn|
    conn.exec('SELECT * FROM recipes ORDER BY name;')
  end

  results.to_a
end

def get_recipe_info(id)
  query =%Q{SELECT * FROM recipe_info
            WHERE id = $1;
            }

    results = db_connection do |conn|
      conn.exec(query, [id])
    end

  results.to_a
end

###########################################################################
###########################################################################
## ROUTES
###########################################################################

get '/recipes' do

  @recipes = get_all_recipes

  erb :'recipes/index'
end

get '/recipes/:id' do

   @recipe_cards = get_recipe_info(params[:id])
   erb :'recipes/show'
 end
