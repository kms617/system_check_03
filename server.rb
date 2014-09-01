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

def get_all_recipes(order_param, offset)
  query= %Q{SELECT * FROM recipes ORDER BY #{order_param} LIMIT 20 OFFSET #{offset};}

  results = db_connection do |conn|
    conn.exec(query)
  end

  results.to_a
binding.pry
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

def count_recipes
  query = "SELECT COUNT(*) FROM recipes;"

  count = db_connection do |conn|
    conn.exec(query)
  end

  count.to_a.first["count"].to_i
end

###########################################################################
###########################################################################
## ROUTES
###########################################################################

get '/recipes' do
  recipe_count = count_recipes

  if recipe_count % 20 == 0
    @last_page = recipe_count / 20
  else
    @last_page = recipe_count / 20 + 1
  end

  @page_no = (params[:page] || 1).to_i
  offset = (@page_no = 1) * 20
  @order_param = params[:order] || 'name'
  @recipes = get_all_recipes(@order_param, offset)

  erb :'recipes/index'
end

get '/recipes/:id' do

   @recipe_cards = get_recipe_info(params[:id])
   erb :'recipes/show'
 end
