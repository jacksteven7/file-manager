# README

## Settings

* Clone repository 
  git clone https://github.com/jacksteven7/file-manager.git

* Go inside the project
`cd file-manager`

* Bundle the project
`bundle install`

* Create databases
`rake db:create`

* Run migrations
`rake db:migrate`

* Start server
`rails s`

* Run specs

in another tab, run `rspec` to run all the specs


## Solution 

> POST `/file`, params: { name: string, tags: array }


> GET `/files/:tag_search_query/:page`, params: { tag_search_query: <string>, page: <int> }



