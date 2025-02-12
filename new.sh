#!/bin/bash

read -p "project name: " name

cargo new $name
cd $name

rustup target add wasm32-unknown-unknown
cargo install wasm-bindgen-cli
cargo install --locked trunk

cargo add yew --features csr
cargo add yew-router
# cargo add wasm-bindgen
# cargo add wasm-bindgen-futures
cargo add gloo

mkdir ./content

mkdir ./src/pages
mkdir ./src/components

echo "/target
/dist" > ./.gitignore

echo "<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"UTF-8\"/>
    <link data-trunk rel=\"sass\" href=\"index.scss\"/>
    <link data-trunk rel="copy-dir" href="content"/>
    <!-- <link rel=\"stylesheet\" href=\"./index.css\"/> -->
    <title>hello world</title>
  </head>
  <body></body>
</html>" > index.html

echo "html,body {
    height:100%;
    width:100%;
    margin:0;
}

body {
  align-items: center;
  display: flex;
  justify-content: center;
  font-size: 1.5rem;
}

main {
  font-family: sans-serif;
  text-align: center;
}" > index.scss

echo "mod components;
mod pages;

use router::{switch, Route};
use yew::prelude::*;
use yew_router::prelude::*;

fn main() {
    yew::Renderer::<App>::new().render();
}

#[function_component(App)]
fn app() -> Html {
    html! {
        <BrowserRouter>
            <Switch<Route> render={switch}/>
        </BrowserRouter>
    }
}

mod router {
    use yew::prelude::*;
    use yew_router::prelude::*;

    use crate::pages::{home::HomePage, not_found::NotFoundPage};

    #[derive(Clone, Routable, PartialEq)]
    pub enum Route {
        #[at(\"/\")]
        Home,
        #[not_found]
        #[at(\"/404\")]
        NotFound,
    }

    pub fn switch(routes: Route) -> Html {
        match routes {
            Route::Home => html! {<HomePage/> },
            Route::NotFound => html! {<NotFoundPage/> },
        }
    }
}
" > ./src/main.rs

> ./src/components/mod.rs

echo "pub mod home;
pub mod not_found;" > ./src/pages/mod.rs

home="./src/pages/home.rs"
not_found="./src/pages/not_found.rs"

echo "use yew::prelude::*;

#[function_component(HomePage)]
pub fn home_page() -> Html {
    html!{
        <main>
            <h1>{\"Home page\"}</h1>
        </main>
    }
}" > $home

echo "use yew::prelude::*;

#[function_component(NotFoundPage)]
pub fn not_found_page() -> Html {
    html!{
        <main>
            <h3>{\"404: Page not found\"}</h3>
        </main>
    }
}" > $not_found

code .
# trunk serve
