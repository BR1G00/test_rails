# README

## Setup:

```bash
bundle install
yarn install

rails db:create db:migrate
rails db:seed
```

Per avviare il server:
```bash
rails server
bin/webpack-dev-server
```

Per avviare i test:

```bash
bundle exec rspec
```

### Compiti:

a) L'api corrente /api/posts ha un problema di performance molto comune. Qual è? Come si potrebbe risolvere?

Il problema principale è che vengono recuperati tutti i post in un'unica query. Successivamente viene fatta una query per ogni singolo post per reguperare i tags collegati e questo può rallentare l'esecuzione nel caso in cui ci siano parecchi post.

La query da eseguire per migliorare il risultato è questa: SELECT * FROM posts LEFT JOIN tags ON tags.post = posts.id;
In questo modo vengono reuperati tutti i post con tutti i tag associati ad esso, ma per ogni post avrei una duplicazione, tante volte quanti sono i tag associati ad esso. Quindi dovrei raggruppare i dati tramite ruby.
Ad esempio se un post possiede 4 tag ottengo 4 righe che fanno riferimento a quel post.
Quindi per ottimizzare si può fare così: 
```sql
SELECT 
  posts.id AS id,
  posts.title AS title,
  string_agg(tags.name, ',') AS tags
FROM posts
LEFT JOIN tags ON tags.post_id = posts.id
GROUP BY posts.id;
```

una soluzione in ruby sarebbe questa 

```ruby
Post.joins(:tags)
    .select('posts.id AS id, posts.title AS title, string_agg(tags.name, \',\') AS tags')
    .group('posts.id')
```

In questo modo ottengo per ogni post una singola riga in cui i tag associati sono separati da virgola.
Entrambe le soluzioni in ogni caso effettuano una sola query al DB.

b) Implementare una nuova API nel PostsController che, ricevendo in GET un parametro "term" permetta di cercare per nome e per tag i post.

Ad esempio, cercando "gatto", verrà trovato un post che contiene la parola gatto o che ha almeno un tag che si chiama "gatto".

Per l'implementazione, utilizzare l'approccio "TDD". Per farla semplice, implementa semplicemente un test nella cartella spec/requests similare a quello già fatto per l'index

c) Implementare in Vue un'input form, modificando il componente app.vue, che permetta di filtrare i post utilizzando l'API creata precedentemente.
