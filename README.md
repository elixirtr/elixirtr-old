# elixir |> turkiye() topluluk websitesi

# kurulum

```bash
# repoyu klonlayin
git clone git@github.com/elixirtr/elixirtr.git && cd elixirtr

# hex paketlerini cekin
mix deps.get

# .env dosyasini ayarlayin
cp .env.sample .env
vim .env

# calistirin
source .env && mix phx.server
# ve ya
source .env && iex -S mix phx.server
```

# ornek kullanici ve sirketler ekleyin

```bash
source .env && iex -S mix phx.server
Erlang/OTP 21 [erts-10.3] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

[info] Running ExtrWeb.Endpoint with cowboy 2.6.3 at 0.0.0.0:4000 (http)
[info] Access ExtrWeb.Endpoint at http://localhost:4000
Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> for i <- 0..100, do: Extr.People.create_user(%{name: Faker.Name.name(), title: Faker.Name.title(), email: Faker.Internet.email(), avatar: Faker.Avatar.image_url(200, 200), password: "password", password_confirmation: "password"})

iex(n)> for i <- 0..100, do: Extr.Corporation.create_company(%{name: Faker.Company.name(), title: Faker.Name.title(), logo: Faker.Avatar.image_url(100, 100), added_by: 1})
```

# yapilacaklar

- [x] alchemists sayfa tasarimi
- [x] github, gitlab authentication
- [-] manuel kayit
- [ ] alchemist detay sayfasi tasarimi
- [ ] sirket ekleme, silme, gosterme vs
- [ ] rehber dokuman paylasimi
- [ ] bulten abonelik sistemi
