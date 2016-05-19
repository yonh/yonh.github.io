#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'sinatra'
require 'active_record'


require File.expand_path("models.rb")


dbconfig = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)



get '/' do
	redirect "/category"
end
get '/category' do
	@categories = Category.all.order("sort")
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
