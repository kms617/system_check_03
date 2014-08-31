CREATE VIEW  recipe_info AS
  SELECT recipes.id, recipes.name, recipes.description, recipes.instructions,
  ingredients.name AS ingredients_list
  FROM recipes
  JOIN ingredients ON ingredients.recipe_id = recipes.id;
