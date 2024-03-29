# FutaGuard 的公共 DNS 服務 (具備廣告過濾功能)

## 前言

- 目前有 3 台伺服器運作中
- 使用 [AdGuard Home](https://adguard.com/en/adguard-home/overview.html) 穩定版作為 DNS 伺服器
- DNS 伺服器僅提供 DoT 及 DoH 查詢
- 服務位址請向低吸索取
- 有任何問題請至 Telegram 群或者發 [issue](https://github.com/FutaGuard/Public-DNS/issues) 告知

## 目錄

- [使用的過濾清單 (依訂閱順序排序)](#使用的過濾清單-依訂閱順序排序)
- [DoT & DoH 使用方式](#dot--doh-使用方式)

## 使用的過濾清單 (依訂閱順序排序)

- [毫無反應](https://bestpika.github.io/abp/hosts.txt)\
  解決部分網站異常使用。
- [FutaFilter](https://filter.futa.gg/hosts.txt) [(首頁)](https://github.com/FutaGuard/FutaFilter)\
  本專案負責維護的過濾清單，跟第一個一樣是處理一些網站的異常情況。
- [NSABlocklist](https://github.com/CHEF-KOCH/NSABlocklist/raw/master/HOSTS/HOSTS)\
  HOSTS file and research project to block all known NSA / GCHQ / C.I.A. / F.B.I. spying server.
- [AdGuard DNS](https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt)\
  AdGuard 官方的 DNS 過濾清單。
- [280blocker](https://filters.futa.gg/280blocker/280blocker_adblock.txt) [(首頁)](https://280blocker.net)\
  日本人維護的過濾清單。目標是處理 mobile 的廣告，大部分的過濾域名是 `.jp` 結尾。
- [SomeoneWhoCares](https://someonewhocares.org/hosts/zero/hosts) [(首頁)](https://someonewhocares.org)\
  主要是用來過濾間諜、木馬網站，兼有過濾廣告功能。
- [NeoDev](https://github.com/neodevpro/neodevhost/raw/master/lite_adblocker) [(首頁)](https://github.com/neodevpro/neodevhost)\
  整合清單型 (包含白名單)。
- [AdAway](https://adaway.org/hosts.txt) [(首頁)](https://adaway.org)\
  應用程式 [AdAway](https://f-droid.org/packages/org.adaway/) 使用的過濾清單。
- [AdAway (Japan Enhanced)](https://logroid.github.io/adaway-hosts/hosts_no_white.txt) [(首頁)](https://logroid.github.io/adaway-hosts/)\
  基於 AdAway 並增加一些日本網站的過濾清單。
- [Malware Domain Blocklist by RiskAnalytics](https://mirror1.malwaredomains.com/files/domains.hosts) [(首頁)](https://www.malwaredomains.com)\
  故名思義，這個過濾清單是針對惡意域名的。
- Phishing Army [基本](https://phishing.army/download/phishing_army_blocklist.txt) [延伸](https://phishing.army/download/phishing_army_blocklist_extended.txt) [(首頁)](https://phishing.army)\
  針對釣魚網站的過濾清單。
- [CoinBlockerLists by ZeroDot1](https://zerodot1.gitlab.io/CoinBlockerLists/hosts) [(首頁)](https://zerodot1.gitlab.io/CoinBlockerListsWeb/)\
  針對網頁挖礦的過濾清單。
- [Spam404](https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt) [(首頁)](https://github.com/Spam404/lists)
  
- [URLhaus](https://curben.gitlab.io/malware-filter/urlhaus-filter-agh-online.txt) [(首頁)](https://gitlab.com/curben/urlhaus-filter)\
  故名思義，這個過濾清單是針對惡意域名的。
- [NoCoin Filter List](https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt)\
  Block lists to prevent JavaScript miners.
## DoT & DoH 使用方式

### Windows

<details><summary>展開</summary>

- 安裝最新版 [AuroraDNS.GUI](https://github.com/mili-tan/AuroraDNS.GUI/releases) 後開啟主視窗戳「設置」。\
![win_01](https://p176.p0.n0.cdn.getcloudapp.com/items/Apujg1pP/Snipaste_2020-05-12_11-54-58.png)

- 依照紅框圈選的部分來設定，完成後點擊確定。\
![win_02](https://p176.p0.n0.cdn.getcloudapp.com/items/geuWQY5b/2.png)

- 最後點擊最左側的圖是更換系統 DNS。\
![win_03](https://p176.p0.n0.cdn.getcloudapp.com/items/kpuLrmPp/3.png)

- 最後點開 <https://check.futa.gg> 測試。

</details>
