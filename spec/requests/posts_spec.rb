require 'rails_helper'

RSpec.describe 'Post' do

  describe 'GET /api/posts' do
    it 'lists posts' do
      post = Post.create!(title: 'Foo', tags: [Tag.new(name: 'bar')])

      get api_posts_path(format: 'json')
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json[0]['title']).to eq(post.title)
      expect(json[0]['tags'].count).to eq(post.tags.count)
      expect(json[0]['tags'].first['name']).to eq(post.tags.first.name)
    end
  end


  describe 'GET /api/posts/search' do
    it 'searches posts by title' do
      post = Post.create!(title: 'gatto', tags: [Tag.new(name: 'gatto')])

      get api_posts_search_path(format: 'json', term: 'gatto')
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json[0]['title']).to eq(post.title)
    end

    it 'searches posts by tag' do
      post = Post.create!(title: 'gatto', tags: [Tag.new(name: 'gatto')])

      get api_posts_search_path(format: 'json', term: 'gatto')
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json[0]['tags'].count).to eq(post.tags.count)
      expect(json.map { |post| post['tags'] }).to include([post.tags])
    end
  end
end