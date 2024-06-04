# FutaGuard 的公共 DNS 服務 (具備廣告過濾功能)

## 前言

- 目前有 4 台伺服器運作中
- 使用 [AdGuard Home](https://adguard.com/en/adguard-home/overview.html) 穩定版作為 DNS 伺服器
- DNS 伺服器僅提供 DoT 及 DoH 查詢
- 有任何問題請至 [Telegram 群](https://t.me/AdBlock_TW)或者發 [issue](https://github.com/FutaGuard/Public-DNS/issues) 告知

## 伺服器網址

DNS-over-HTTPS: 
 - 🇹🇼 https://doh.futa.gg/dns-query
 - 🇯🇵 https://doh.futa.app/dns-query

DNS-over-TLS:
 - 🇹🇼 tls://dot.futa.gg
 - 🇯🇵 tls://dot.futa.app

## 目錄

- [使用的過濾清單 (依訂閱順序排序)](#使用的過濾清單-依訂閱順序排序)
- [DoT & DoH 使用方式](#dot--doh-使用方式)

## 使用的過濾清單 (依訂閱順序排序)

- [LowTechFilter](https://filter.futa.gg/hosts.txt) [(首頁)](https://github.com/FutaGuard/FutaFilter)\
  本專案負責維護的過濾清單，針對台灣人使用場景封鎖詐騙或是廣告清單。
- [LowTechFilter TW165](https://filter.futa.gg/TW165_abp.txt)\
  由台灣警政署 165 單位提供，本專案負責整理後提供。
- [LowTechFilter NRD](https://filter.futa.gg/nrd/past-03day_hosts.txt)\
  由 FutaGuard 網羅自網路上各種近期註冊網域清單。
- [Phishing URL Blocklist](https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt)\
  由 AdGuard 官方整理的釣魚網址清單。
- [AdGuard DNS](https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt)\
  AdGuard 官方的 DNS 過濾清單。
- [SomeoneWhoCares](https://someonewhocares.org/hosts/zero/hosts) [(首頁)](https://someonewhocares.org)\
  主要是用來過濾間諜、木馬網站，兼有過濾廣告功能。
- [AdAway (Japan Enhanced)](https://logroid.github.io/adaway-hosts/hosts_no_white.txt) [(首頁)](https://logroid.github.io/adaway-hosts/)\
  基於 AdAway 並增加一些日本網站的過濾清單。
- [NoCoin Filter List](https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt)\
  Block lists to prevent JavaScript miners.
- [OISD Blocklist Small](https://adguardteam.github.io/HostlistsRegistry/assets/filter_5.txt) [首頁](https://oisd.nl/setup)\
  OISD 清單
   