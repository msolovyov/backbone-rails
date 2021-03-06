require 'test_helper'
require 'generators/generators_test_helper'
require "generators/backbone/scaffold/scaffold_generator"

class ScaffoldGeneratorTest < Rails::Generators::TestCase
  include GeneratorsTestHelper
  tests Backbone::Generators::ScaffoldGenerator
  arguments %w(Post title:string content:string)
  
  test "generate controller scaffolding" do
    run_generator
    
    assert_file "#{backbone_path}/controllers/posts_controller.coffee" do |controller|
      assert_match /class Dummy.Controllers.PostsController extends Backbone.Controller/, controller
      assert_match /newPost: ->/, controller
      
      %w(NewView IndexView ShowView EditView).each do |view|
        assert_match /new Dummy.Views.Posts.#{view}/, controller
      end
      
    end
  end
  
  test "generate view files" do
    run_generator
    
    assert_file "#{backbone_path}/views/posts/index_view.coffee" do |view|
      assert_match /#{Regexp.escape('JST["backbone/templates/posts/index"]')}/, view
      assert_match /#{Regexp.escape('this.template(posts: this.options.posts.toJSON() ))')}/, view
      assert_match /#{Regexp.escape("new Dummy.Views.Posts.PostView({model : post})")}/, view
    end
    
    assert_file "#{backbone_path}/views/posts/show_view.coffee" do |view|
      assert_match /class Dummy.Views.Posts.ShowView extends Backbone.View/, view
      assert_match /#{Regexp.escape('this.template(this.options.model.toJSON() )')}/, view
      assert_match /#{Regexp.escape('template: JST["backbone/templates/posts/show"]')}/, view
    end
    
    assert_file "#{backbone_path}/views/posts/new_view.coffee" do |view|
      assert_match /class Dummy.Views.Posts.NewView extends Backbone.View/, view
      assert_match /#{Regexp.escape('this.template(@options.model.toJSON() )')}/, view
      assert_match /#{Regexp.escape('JST["backbone/templates/posts/new"]')}/, view
      assert_match /#{Regexp.escape('"submit #new-post": "save"')}/, view
    end
    
    assert_file "#{backbone_path}/views/posts/edit_view.coffee" do |view|
      assert_match /class Dummy.Views.Posts.EditView extends Backbone.View/, view
      assert_match /#{Regexp.escape('JST["backbone/templates/posts/edit"]')}/, view
      assert_match /#{Regexp.escape('"submit #edit-post": "update"')}/, view
    end
    
    assert_file "#{backbone_path}/views/posts/post_view.coffee" do |view|
      assert_match /class Dummy.Views.Posts.PostView extends Backbone.View/, view
      assert_match /#{Regexp.escape('this.template(this.options.model.toJSON() )')}/, view
      assert_match /#{Regexp.escape('JST["backbone/templates/posts/post"]')}/, view
    end
  end
  
  test "generate template files" do
    run_generator
     
    assert_file "#{backbone_path}/templates/posts/index.jst.ejs"
    
    assert_file "#{backbone_path}/templates/posts/new.jst.ejs" do |view|
      assert_match /#{Regexp.escape('<form id="new-post" name="post">')}/, view
    end
    
    assert_file "#{backbone_path}/templates/posts/edit.jst.ejs" do |view|
      assert_match /#{Regexp.escape('<form id="edit-post" name="post">')}/, view
    end
    
    assert_file "#{backbone_path}/templates/posts/show.jst.ejs"
    assert_file "#{backbone_path}/templates/posts/post.jst.ejs"
   end
   
  test "backbone model generator is invoked" do
    run_generator
    
    assert_file "#{backbone_path}/models/post.coffee" do |model|
      assert_match /url: '\/posts'/, model
      assert_match /paramRoot: 'post'/, model
      
      assert_match /title: null/, model
      assert_match /content: null/, model
    end
  end
  
end