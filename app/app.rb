#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'sinatra'
require 'active_record'
require 'awesome_print'


require File.expand_path("models.rb")


ActiveRecord::Base.default_timezone = :local
dbconfig = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)



get '/' do
	redirect "/category"
end
get '/category' do
	@categories = Category.all.order("sort")
	ap @categories
	erb :index
end

post '/category/add' do
	cate = Category.create(title: params["title"], sort: params["sort"])
	cate.created_at = Time.now
	cate.updated_at = Time.now
	cate.save

	redirect '/category'
end


get '/category/edit/:id' do
	@item = Category.find_by(id: params["id"])
	erb :edit
end

post '/category/edit' do
	cate = Category.find_by(id: params["id"])
	if cate then
		cate.updated_at = Time.now
		cate.title = params["title"]
		cate.sort = params["sort"]
		cate.save
		redirect "/"
	end
end

get '/category/del/:id' do
	cate = Category.find_by(id: params["id"])
	if cate then
		cate.destroy
		redirect "/category"
	end
end

get '/posts/new' do
	@categories = Category.all.order("sort")
	erb :posts_new
end


post '/posts/add' do
	cate = Category.find_by(id: params["category_id"])

	if cate == nil
		"category not exists"
	else
		post = Post.new(params)
		if post.save
			redirect '/'
		else
			
		end
		#post = Post.create
		#post.title = params["title"]
		#ap post
		#params.to_s
	end
end

get '/posts/open/id' do
	
end

get '/category/posts/:id' do
	@category = Category.find_by(id: params[:id])
	ap @category.posts
	erb :category
end



get '/build/index' do
	categories = Category.all.order("sort");
	file = "../index.md"
	
	File.open(file, 'w') do |f|
		categories.each do |cat|
			f.puts "### #{cat.title}"
			cat.posts.each do |c|
				f.puts "* #{c.title}"
			end
			f.puts "\n\n\n\n"
		end
	end
	system("open /Users/yonh/git/yonh.github.io/index2.md")
	"done..."
end


