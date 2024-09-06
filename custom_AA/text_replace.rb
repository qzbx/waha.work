# edited on 201115
require "date"
require "digest"

# おみくじ各運勢のしきい値
$wahakichi_thr = 5
$daikichi_thr  = 18 
$chukichi_thr  = 46
$shokichi_thr  = 72 
$kyo_thr       = 88
$daikyo_thr    = 99
$wahakyo_thr   = 100 # ここは固定（rand の大きさに一致）

# おみくじ
def omikuji_func(omikuji_rand)
  omikuji = 
    if omikuji_rand < $wahakichi_thr then "わは吉"
    elsif omikuji_rand < $daikichi_thr then "大吉"
    elsif omikuji_rand < $chukichi_thr then "中吉"
    elsif omikuji_rand < $shokichi_thr then "小吉"
    elsif omikuji_rand < $kyo_thr then "凶"
    elsif omikuji_rand < $daikyo_thr then "大凶"
    else "わは凶"
    end
  return omikuji
end

# 四字熟語
def yoji_func(omikuji_rand, omikuji_random)

    wahalucky_table = [ # わは吉専用
      "株主総会", "乱闘議会", "数え役満", "さぼてん", "あどみん", 
      "五千兆円", "無想陰殺", "鼻ふぐり", "唯我独尊", "天下無双", 
      "抱き合え", "大仏建立", "わはー汁", "闇の帝王", "全シュポ", 
      "新興宗教", "わはー砲", "完全武装", "がらくた", "へべれけ", 
      "強行突撃", "絨毯爆撃", "ﾜﾊﾜﾊﾀﾞﾝｽ", "ハバネロ", "札束乱舞", 
      "真理の扉", "金と権力", "ＷＡＨＡ", "ぼろ儲け", "マボドフ", 
	  "暴力革命", "ゴキゲン",
    ]

    very_lucky_table = [ # 大吉専用
      "　ネ申　", "おふとん", "天才博士", "絶対王者", "世界平和", 
      "光の戦士", "一攫千金", "一粒万倍", "総理大王", "天下大吉",
      "酒池肉林", "めでたい", "筆頭株主", "タワマン", "わはー祭", 
      "ﾋｮﾎﾎﾎﾎﾎﾎ", "ｿｲﾔｯｿｲﾔｯ", "恋の予感", "金の匂い", "特上握り", 
      "激辛中華", "高級料亭", "ヒレカツ", "ＳＳレア", "大当たり",
    ]

    lucky_table = [ # イイ感じのテーブル（大吉 中吉）
      "みみつき", "推しカプ", "幽寂閑雅", "わはー党", "みみずれ", 
      "ｲﾝﾌﾙｴﾝｻｰ", "ポヨヨン", "炬燵布団", "時は戦国", "しっぽり", 
      "みみなし", "すやぽよ", "あげぽよ", "完全変態", "わはー城", 
      "麻婆豆腐", "らーめん", "回転寿司", "パエリア", "ニーハイ", 
      "焼肉定食", "すき焼き", "わはー像", "肩ロース", "生ビール",
	  "疾風怒濤", "ステーキ", "わはー教",
    ]

    neutral_table = [ # 可もなく不可もなく（中吉 小吉）
      "雲雨巫山", "有象無象", "ヤンキー", 
      "女装界隈", "カナダ語", "線香花火", "菓子パン", "ドカ盛り",
      "濃厚接触", "ドンパオ", "調整豆乳", "段ボール", "メス男子", 
      "マウント", "全裸待機", "幼児退行",
      "らーぬん", "焼きそば", "ゴマ団子", "こしあん", "つぶあん", 
      "おにぎり", "たこ焼き", "どら焼き", "焼きいも", "爆音国歌", 
      "ニンジャ", "ホカホカ", "とんこつ", "赤唐辛子", "空中浮遊",
      "ざるそば", "青唐辛子", "おまんま", "深夜暴食", "呆然自失",
	  "にゃーん", "ビリヤニ", "音速飛行", "ドスケベ", "集団呆然", 
	  "もくもく", "驕奢淫佚", "誨淫導欲", "奢侈淫佚", "奇技淫巧",
	  "Ａ級戦犯", "淫祠邪教",
    ]

    unlucky_table = [ # ダメなテーブル（凶）
      "疲労困憊", "夢のあと", "顎関節症", "にわか雨", 
      "朝歌夜絃", "遊生夢死", "遊冶懶惰", "佚楽放恣", "坐食逸飽",
      "翫歳愒日", "蹉跎歳月", "曠日弥久", "禽息鳥視", "野獣先輩", 
      "リテイク", "昼夜逆転", "徒手空拳", "忘れもの", "承認欲求",
      "連戦連敗", "電池切れ", "尻丸出し", "どうして", 
      "ぽんこつ", "幻視幻聴", "自己責任", "ネコババ",
      "のけもの", "妨害電波", "時間切れ", "何もない", "精神病棟",
      "具なし麺", "迷宮入り", "モブおじ", "猛獣注意", "百姓一揆",
      "特にない", "やり直し", "反省して", "背水の陣", "ドムドム", 
	  "パチモン", "敗色濃厚", "大根役者", "失敗眉毛", "無理せず",
	  "灰身滅智",
    ]

    very_unlucky_table = [ # 大凶専用
      "地獄行き", "クソゲー", "爆発四散", "・・・。", "クソリプ", 
      "ハイ０点", "無職童貞", "メンヘラ", "もうダメ", "回線落ち", 
      "御愁傷様", "流石に草", "阿鼻叫喚", "四面楚歌",
      "無知蒙昧", "運の尽き",
	  "お気の毒", "ヤク漬け", "背水の陣", "そっかぁ",
    ]

    wahaunlucky_table = [ # わは凶専用
	  "完全沈黙", "永久追放", "垢ＢＡＮ", 
    ]
      
    # 各運勢での四字熟語テーブル
    wahakichi_table = wahalucky_table                     # わは吉
    daikichi_table  = very_lucky_table + lucky_table      # 大吉
    chukichi_table  = lucky_table + neutral_table         # 中吉
    shokichi_table  = neutral_table                       # 小吉
    kyo_table       = unlucky_table                       # 凶
    daikyo_table    = very_unlucky_table                  # 大凶
    wahakyo_table   = wahaunlucky_table                   # わは凶

    yoji = 
      if omikuji_rand < $wahakichi_thr  
        wahakichi_table[omikuji_random.rand(wahakichi_table.length)]
      elsif omikuji_rand < $daikichi_thr  
        daikichi_table[omikuji_random.rand(daikichi_table.length)]
      elsif omikuji_rand < $chukichi_thr 
        chukichi_table[omikuji_random.rand(chukichi_table.length)]
      elsif omikuji_rand < $shokichi_thr 
        shokichi_table[omikuji_random.rand(shokichi_table.length)]
      elsif omikuji_rand < $kyo_thr 
        kyo_table[omikuji_random.rand(kyo_table.length)]
      elsif omikuji_rand < $daikyo_thr 
        daikyo_table[omikuji_random.rand(daikyo_table.length)]
      else 
        wahakyo_table[omikuji_random.rand(wahakyo_table.length)]
      end
  return yoji
end

# ガチャ
def gacha_func(seed, omikuji_rand)
  ur_table = [ # UR
    "あどみん", "裏わはー", "がらくた", 
  ]

  ssr_table = [ # SSR
    "わはーキング", "わはー仙人", "疾風怒濤のわはー軍団", "鼻ふぐり", 
    "いにしえのわはー", "めざめたわはー", "わはー大社", 
    "光り輝く黄金のわはー", "歴戦のみみずれ", "ワハ王", 
    "ワハンカーメン", "WAHA in BLACK", "内閣わはー大臣", 
    "チリヤマビスカーチャ", "ちんちくりん", "天才わはー博士", 
    "和覇亞組", "わはー（無敵状態）", "風神わはー＆雷神わはー", 
    "トリプルチーズワーハー", "竹馬炒飯師匠", "沈黙のみみつき", 
    "封印されしワハゾディア", "ワハーホールディングス㈱", 
    "おおだるまおとし", "ぽ", "ばんばん初手破損部部長", "しろいあくま", 
    "人をダメにするワハァ", "ワハプルギスの夜", "札束風呂でほほえむわはー",
    "インペリアルわはー",
  ]

  sr_table = [ # SR
    "だるまおとし", "スーパーみみずれ", "セミコロン卿", "わはー神社", 
    "ダンシングわはー", "わはー（大盛り）", "わはー（幼獣）", "わは狗", 
    "激辛わはー", "お月見わはー", "みみより", "ダブルチーズワーハー", 
    "四字熟語看板係", "わはー像", "ばんばん初手破損部員", "メンヘラわはー", 
    "瓶詰めわはー", "ゲーミングわはー", "苔むしたわはー", "ほのぼのわはー", 
    "オフロアウトホカホカマン", "茶柱わはー", "風化したわはー", "オフトン", 
    "わはーのぬいぐるみ", "わはー剣", "わはー砲", "風雲わはー城", "わは殿", 
    "わはークッション", "わはースタンプ", "濃縮わはー", "みみっく", "マボドフ", 
    "ドヤわはー", "天然わはー", "養殖わはー",
    "エゾミミツキ", "オオミミツキ", "ミミツキモドキ",
    "ニホンミミツキ", "マルミミツキ",
  ]

  r_table = [ # R
    "みみつき", "みみずれ", "みみなし",
    "みみつき", "みみずれ", "みみなし", "偵察兵", "ワハボット", 
  ]

  n_table = [ # N
    "わはー", "わはー", "ｼｭﾎﾟｰﾝ",
  ]

  # レア度のしきい値（最後の1000は固定・使わないけどわかりやすさのため）
  thr_table = #しきい値テーブル             UR  SSR   SR     R     N
    if omikuji_rand < $wahakichi_thr   then [3, 640, 980, 1000, 1000] # わは吉
    elsif omikuji_rand < $daikichi_thr then [2, 150, 500,  850, 1000] # 大吉
    elsif omikuji_rand < $chukichi_thr then [1,  60, 400,  750, 1000] # 中吉
    elsif omikuji_rand < $shokichi_thr then [0,  30, 300,  600, 1000] # 小吉
    elsif omikuji_rand < $kyo_thr      then [0,   5, 100,  550, 1000] # 凶
    elsif omikuji_rand < $daikyo_thr   then [0,   0,   0,  200, 1000] # 大凶
    else                                    [0,   0,   0,    0, 1000] # わは凶
    end
  ur_thr  = thr_table[0]
  ssr_thr = thr_table[1]
  sr_thr  = thr_table[2]
  r_thr   = thr_table[3]
  n_thr   = thr_table[4]

  gacha = ""
  for i in 1..10 do # 10連なので10回繰り返し
    gacha_random = Random.new(seed + i) # ガチャ用の乱数生成器
    gacha_rand = gacha_random.rand(1000) # ガチャ本日の乱数 0〜999
    gacha += 
      if gacha_rand < ur_thr  
        "!!!【UR】"+ur_table[gacha_random.rand(ur_table.length)]+" !!!\n"
      elsif gacha_rand < ssr_thr  
        "【SSR】"+ssr_table[gacha_random.rand(ssr_table.length)]+"\n"
      elsif gacha_rand < sr_thr 
        "【SR】"+sr_table[gacha_random.rand(sr_table.length)]+"\n"
      elsif gacha_rand < r_thr 
        "【R】"+r_table[gacha_random.rand(r_table.length)]+"\n"
      else 
        "【N】"+n_table[gacha_random.rand(n_table.length)]+"\n"
      end
  end
  return gacha
end

def text_replace(text, username)

	# seed = 0 # 乱数のシード
    # ユーザーID をシード要素に含める
	# username.each_byte do |c|
	# 	seed += c
    # end
    seed = Digest::SHA256.hexdigest(username).hex # 16進数ハッシュにしたのを数値化
    # シードに日付を追加（シード値が日替わりになるように）
    uday = 366 * Date.today.year + Date.today.yday + 0
    seed += Digest::SHA256.hexdigest(uday.to_s).hex
	omikuji_random = Random.new(seed) # おみくじ用の乱数生成器
    omikuji_rand = omikuji_random.rand(100) # おみくじ本日の乱数 0〜99
	# 不具合お詫び
	if (Date.today.year == 2021) && (Date.today.mon == 9) && (Date.today.mday == 5) then
		omikuji_rand = 1
	end

    # おみくじ
    omikuji = omikuji_func(omikuji_rand)

    # 四字熟語
    yoji = yoji_func(omikuji_rand, omikuji_random)

    # ガチャ
    gacha = gacha_func(seed, omikuji_rand)

    # もくもく
    mokumoku = ["雲", "雲", "雲", "雲", "雲", "雲", "雲", "雲", "雲", "雲", 
                "煙", "煙", "煙", "煙", 
                "曇", "曇", 
                "わ", "わ", "わ", "は", "は", "ー",
                "神", "雨", "颱"]

	fuwafuwa = ['ｼｭｰｸﾘｰﾑ-', 'ｻｸﾗﾓﾁｰ', 'ｱﾝﾊﾟﾝ-', 'ﾓﾁｰ', 'ﾑｼﾊﾟﾝｰ', 
      'ﾒﾛﾝﾊﾟﾝｰ', 'ｱﾝﾏﾝｰ', 'ﾏﾌｨﾝｰ', 'ﾌｰ', 'ﾄﾞﾗﾔｷｰ',
      'ｵﾑﾚﾂｰ', 'ｶﾚｰﾊﾟﾝｰ', 'ｸｻﾓﾁｰ', 'ｶｼﾜﾓﾁｰ', 'ﾜﾀｱﾒｰ',
      'ﾆｸﾏﾝｰ', 'ｼﾌｫﾝｹｰｷｰ', 'ﾏｶﾛﾝｰ', 'ﾏｼｭﾏﾛｰ', 'ﾀﾞｲﾌｸｰ',
      'ﾏﾝｼﾞｭｳｰ', 'ｽｱﾏｰ', 'ﾛｰﾙﾊﾟﾝｰ', 'ｶﾞﾝﾓﾄﾞｷｰ', 'ﾜﾀｶﾞｼｰ', '']

	magic = ["よみがえれ", "きえるがよい", "ねむれ", "加速", "遅延", "回線落ち",
		"世界平和", "人類滅亡", "バルス",
		"光あれ", "焼肉", "寿司", "マボドフ", "闇に飲まれよ", "ビビデバビデブ",
		"アバダケダブラ", "ステーキ", "鬱", "躁", "隕石", "加熱",
		"ピザ", "ラーメン", "パヘェ", "猫", "わはー", "みみずれ",
		"ファイガ", "ブリザガ", "サンダガ", "メテオ", "フレア", "ジハード",
		"ケアル", "レイズ", "レベル５デス", "ホーリー",
		"Welcome to ヨォドォバァシィカァメェラ。親愛的顧客朋友、你們好。衷心歡迎您光臨友都八喜。友都八喜是日本著名的大型購物中心。精明商品將近一百萬種、數碼相機、攝像機、名牌手錶、化妝品、電子遊戲、名牌箱包等應有盡有。最新的款式、最優惠的價格、最優質的服務"]

	replaced = text.gsub(/：おみくじ/, "《わはーおみくじ》\n @"+username+"@waha.work の今日の運勢は【"+omikuji+"】！\n\n：みみつき")

	return replaced.gsub(/：わはー/, "＿人人人人人人＿\n＞ (っ＾ω＾c) ＜\n￣Y^Y^Y^Y^Y^Y￣")
		.gsub(/：みみつき/, "　　　∧　∧\n　　(　＾ω＾ )\n　　(っ　 　 c)\n￣￣￣￣￣￣￣￣￣")
		.gsub(/：みみなし/, "　\n　　(　＾ω＾ )\n　　(っ　 　 c)\n￣￣￣￣￣￣￣￣￣")
		.gsub(/：みみずれ/, "　"*rand(10)+"∧　∧\n　　(　＾ω＾ )　　\n　　(っ　 　 c)　　\n￣￣￣￣￣￣￣￣￣")
		.gsub(/：まるみみつき/, "　　　∩　∩\n　　(　＾ω＾ )\n　　(っ　 　 c)\n￣￣￣￣￣￣￣￣￣")
		.gsub(/：うさみみつき/, "　　　ᕱ　ᕱ\n　　(　＾ω＾ )\n　　(っ　 　 c)\n￣￣￣￣￣￣￣￣￣")
		.gsub(/：まんぷく/, "　　∧　∧\n　(　＾ω＾ )\n　/　       ⌒ヽ\n（_人__＿__つ_つ")
		.gsub(/：ちんもく/, "　　　∧　∧\n・・(　＾ω＾ )・・。\n　　(っ　 　 c)\n￣￣￣￣￣￣￣￣￣")
		.gsub(/：まほう/, rand(2+magic.length)<2?(rand(2)==0?"不発！\nc(　＾ω＾)っ―☆":"「召喚」\nc(　＾ω＾)っ―☆*'``*:.｡. .｡.:*･゜ﾟ･*\n\n　　　　　　　　\\(っ＾ω＾c)/"):"「"+magic[rand(magic.length)]+"」\nc(　＾ω＾)っ―☆*'``*:.｡. .｡.:*･゜ﾟ･*")
		.gsub(/：おちゃ/, "　　　　　（⌒)\n　　∧　∧  （～)\n　(　＾ω＾ )( )\n　{￣￣￣￣￣} \n　{～￣お＿＿}\n　{～￣茶＿＿}\n　{＿＿＿＿＿}\n　 ┗━━━┛")
		.gsub(/：ふわふわ/, "╭　 ͡　　╮\n( ・ω・  　)"+fuwafuwa[rand(fuwafuwa.length)])
		.gsub(/：なんだ/, "　　∧　∧\n　 ∩＾ω＾) な ん だ\n　｜　　cﾉ\n　｜　＿＿⊃\n　 し′\n")
		.gsub(/：うそか/, "　  ∧　∧\n　(＾ω＾∩　う そ か\n　(っ　　｜\n　⊂＿_　｜\n　　　　`Ｊ\n")
		.gsub(/：おっおっおっ/, "　　  ∧　∧\n　　(　　　) おっおっ\n　 ／　　_つ　おっ\n　(_(_⌒)′\n　 ∪(ノ")
		.gsub(/：ばんばん/, rand(3)==0?"　　　　　;　'　　　　　;\n　　　　　　＼,,(' ⌒｀;;)\n　　　　　　(;; (´･:;⌒)/\n　　∧　∧(;.　(´⌒` ,;) ）　’\n　(　＾ω((´:,(’ ,； ;'),`\n　(っ ＿＿/￣￣￣/＿＿\n　　　＼/＿＿＿/":"ﾊﾞﾝﾊﾞﾝﾊﾞﾝﾊﾞﾝﾊﾞﾝﾊﾞﾝﾊﾞﾝﾊﾞﾝﾊﾞﾝ\nﾊﾞﾝ　  ∧　∧　　ﾊﾞﾝﾊﾞﾝﾊﾞﾝﾊﾞﾝ\nﾊﾞﾝ（∩＾ω＾）　ﾊﾞﾝﾊﾞﾝﾊﾞﾝﾊﾞﾝ\n　＿/_ﾐつ/￣￣￣/\n　　　＼/＿＿＿/￣")
		.gsub(/：だるまおとし/, (rand(15)==0?"　　　　　　三　∧　∧　ｼｭﾎﾟｰﾝ\n":"　∧　∧\n")+(rand(10)==0?"　　　　　　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(3)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(3)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(4)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n"))
		.gsub(/：おおだるまおとし/, (rand(15)==0?"　　　　　　三　∧　∧　ｼｭﾎﾟｰﾝ\n":"　∧　∧\n")+(rand(10)==0?"　　　　　　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(3)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(2)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(2)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(2)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(2)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(2)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(2)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(2)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(2)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(2)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n")+(rand(3)==0?"　"*rand(6)+"　三(っ＾ω＾c)ｼｭﾎﾟｰﾝ\n":"(っ＾ω＾c)\n"))
		.gsub(/：どどど/, "┣¨┣¨┣¨┣¨┣¨┣¨┣¨┣¨┣¨┣¨\n　三(っ＾ω＾c)　三(っ＾ω＾c)\n　　　三(っ＾ω＾c)　三(っ＾ω＾c)\n三(っ＾ω＾c)　三(っ＾ω＾c)")
		.gsub(/：ぽよん/, "　　　　　　∧　∧\n　　　　　(　＾ω＾ )\n　ﾎﾟﾖﾝ　　( O━━O)\n　　ﾎﾟﾖﾝ 　し｜｜-J\n　　 　　　⊂ニ§ニ⊃\n　　　　　　　§\n　⌒ヽ〃⌒ヽ〃")
		.gsub(/：ろぼっと/, "　　 i..仝＿仝\n　　[　＾ω＾ ]\n　　[＞　 　＜]\n￣￣￣￣￣￣￣￣￣")
		.gsub(/：だんす/, %Q{♪　　∧　∧\n　　(　＾ω＾ ) ))\n　(( (　つ　　ヽ、　♪\n　 　〉　と/　 ) ))\n　　(__／""`^(＿)})
		.gsub(/：ふんか/, "　 　　　　(⌒`⌒)\n　　　　　　ii!i!i　ﾎﾋｮｰｯ\n　 　 　 　／~~~＼\n.⊂⊃ 　 ／　＾ω＾　＼　⊂⊃\n.......,,,,傘傘傘:::::::::傘傘傘.............")
		.gsub(/：じゅうじか/, %Q{　　+　　..　. 　　..　　　.　　+..\n　 ..　:..　　　　 __　　..\n　　　　　 　 　 |: |\n　　　　　　 　 .|: |\n　　 　　　.(二二X二二Ｏ\n　　　 　　 　 　|: |　　　　..:+\n　　　　 ∧　∧　|: |\n　　 　 / ⌒ヽ　)_|; |,_,,\n_,_,_,,＿(,,　　　) ;;;;:;:;;;;:::ヽ,、\n　　　""　""""""""""　"""""",,""/;::;\n　　 ""　,,,　　"""　　""／:;;:\n　　　 ""　　　,,"""""　/;;;::;;::;;:})
		.gsub(/：おふろ/, "　　　○\n＿　　　。　o\n┻┓ ∬　｡　　∧　∧\n　|||。o 　　( ＾ω＾　)\n(￣￣￣o)￣￣￣￣○￣)\n.i￣￣○￣￣○￣oﾟ￣０i\n(＿＿oノ＿O＿ﾟ＿Oo＿)")
		.gsub(/：もくもく/, "　╭◜◝ "+mokumoku[rand(mokumoku.length)]+" ◜◝╮\n　(　っ＾ω＾c　)\n　 ╰◟◞  ͜  ◟◞╯")
		.gsub(/：まっする/, "　 ／ﾌﾌ 　　　　　　 　ム`ヽ\n　/ ノ)　  ∧　∧　　　　)　ヽ\n / ｜　　(　＾ω＾)ノ⌒(ゝ._ノ\n/　ﾉ⌒7⌒ヽーーく　 ＼ ／\n丶＿ ノ ｡　　 ノ､ 　｡|／\n　　 `ヽ `ー-'__人`ーﾉ\n　　 　丶 ￣ _人'彡ﾉ\n　　　ﾉ　　r'十ヽ/\n　　／｀ヽ _/十∨")
		.gsub(/：よじじゅくご/, "@"+username+"@waha.work の今日の四字熟語はこちら！\n\n" + %Q{　　　　∧　∧\n　　　(　＾ω＾ )\n　( )三≡Ｕ≡＝Ｕ二≡≡ )\n　|(|　　　　　　　　|i|\n　|i|　　}+yoji+%Q{　　| |\n　|;|　　　　　　　　|;|\n　(_)≡ 三=＝二＝二≡≡) \n　　　　 　|(i|\n　　　　 　|i |\n　　　　 　|i |\n　　 　" " " " " " " " "})
        .gsub(/：がちゃ/, "《わはー10連ガチャ》\n"+gacha)

end

