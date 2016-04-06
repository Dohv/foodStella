class RecipesController < ApplicationController

  def new
    @recipe = current_user.recipes.build
    @recipe.quantities.build
    @recipe.quantities.last.build_ingredient
    @recipe.instructions.build
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to dashboard_user_path(current_user)
      flash[:success] = "Recipe Created"
    else
      render 'new'
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    @recipe.update_attributes(recipe_params)
      respond_to do |format|
        format.html  { redirect_to recipe_path(@recipe) }
        flash[:success] =  "Recipe Updated"
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @difficulty = get_difficulty(@recipe.difficulty) if @recipe.difficulty
    @meal_type = get_meal_type(@recipe.meal_type) if @recipe.meal_type
    @category = get_category(@recipe.category) if @recipe.category
  end

  def index
    @recipes = current_user.recipes 
  end

  def get_difficulty(diff)
    string = case diff
                when "1"
                  "Easy"
                when "2"
                  "Moderate"
                when "3"
                  "Difficult"
              end
    string
  end

  def get_category(cat)
    string = case cat 
                when "1"
                  "Medit."
                when "2"
                  "Chinese"
                end
    string
  end

  def get_meal_type(typ)
    string = case typ 
                when "1"
                  "Snack"
                when "2"
                  "Side Dish"
                when "3"
                  "Main Dish"
                when "4"
                  "Dessert"
                when "5"
                  "Drink"
                end
    string
  end

  def recipe_params
  	params.require(:recipe).permit(:name, :photo_url, :category, :prep_time, :cook_time, :difficulty, :meal_type, :description,
  	  :quantities_attributes => [
        :id,
        :amount,
        :_destroy,
        :ingredient_attributes => [
          #:id commented bc we pick 'id' for existing ingredients manually and for new we create it
          :name
        ]
      ],
      :instructions_attributes => [:id, :description, :order, :_destroy]
    )
  end
end