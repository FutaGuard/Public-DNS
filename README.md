# FutaGuard 的公共 DNS 服務 (具備廣告過濾功能)

## 前言

- 目前有 2+1 台伺服器運作中
- 使用 [AdGuard Home](https://adguard.com/en/adguard-home/overview.html) 穩定版作為 DNS 伺服器
- DNS 伺服器僅提供 DoT 及 DoH 查詢
- 服務位址請向低吸索取
- 有任何問題請至 Telegram 群或者發 [issue](https://github.com/FutaGuard/Public-DNS/issues) 告知

## 使用的過濾清單 (依訂閱順序排序)

- [某個路人的](https://bestpika.github.io/abp/hosts.txt)\
  解決部分網站異常使用。
- [AdGuardSDNS](https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt)\
  AdGuard 官方的 DNS 過濾清單。
- [280blocker](https://280blocker.net/files/280blocker_domain_ag.txt) [(首頁)](https://280blocker.net)\
  日本人維護的過濾清單。目標是處理 mobile 的廣告，大部分的過濾域名是 `.jp` 結尾。
- [SomeoneWhoCares](https://someonewhocares.org/hosts/zero/hosts) [(首頁)](https://someonewhocares.org)\
  主要是用來過濾間諜、木馬網站，兼有過濾廣告功能。
- [AdAway](https://adaway.org/hosts.txt) [(首頁)](https://adaway.org)\
  應用程式 [AdAway](https://f-droid.org/packages/org.adaway/) 使用的過濾清單。
- [AdAway (Japan Enhanced)](https://logroid.github.io/adaway-hosts/hosts_no_white.txt) [(首頁)](https://logroid.github.io/adaway-hosts/)\
  基於 AdAway 並增加一些日本網站的過濾清單。
- [Malware Domain List](https://www.malwaredomainlist.com/hostslist/hosts.txt) [(首頁)](https://www.malwaredomainlist.com)\
  故名思義，這個過濾清單是針對惡意域名的。
- [Malware Domain Blocklist by RiskAnalytics](https://mirror1.malwaredomains.com/files/domains.hosts) [(首頁)](https://www.malwaredomains.com)\
  同上。
- Phishing Army [基本](https://phishing.army/download/phishing_army_blocklist.txt) [延伸](https://phishing.army/download/phishing_army_blocklist_extended.txt) [(首頁)](https://phishing.army)\
  針對釣魚網站的過濾清單。
- [CoinBlockerLists by ZeroDot1](https://zerodot1.gitlab.io/CoinBlockerLists/hosts) [(首頁)](https://zerodot1.gitlab.io/CoinBlockerListsWeb/)\
  針對網頁挖礦的過濾清單。
- [NSABlocklist](https://github.com/CHEF-KOCH/NSABlocklist/raw/master/HOSTS/HOSTS) [(首頁)](https://github.com/CHEF-KOCH/NSABlocklist/)\
  過濾已知 NSA / GCHQ / C.I.A. / F.B.I. 的~~釣魚~~伺服器（所以我都叫這清單 USASpy）。
- [FutaFilter](https://futaguard.github.io/FutaFilter/hosts.txt) [(首頁)](https://github.com/FutaGuard/FutaFilter)\
  本專案負責維護的過濾清單，跟第一個一樣是處理一些網站的異常情況。
