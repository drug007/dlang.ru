<template lang="pug">
    div
        header
            .container
                router-link.logo(to="/"): img(src="@/assets/dlogo.svg", alt="Dlang.ru")
                nav
                    router-link(to="/") Главная
                    router-link(to="/faq") FAQ
                    router-link(to="/links") Ссылки
                    router-link(to="/book") Online-учебник
                    a(href="https://t.me/dlangru" target="_blank")
                        | Мы в telegram
                        img(src="@/assets/img/telegram.svg", alt="")
        router-view
</template>

<script>

export default {
  name: 'App',
  methods: {
  }
}
</script>

