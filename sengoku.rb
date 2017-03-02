class Sengoku_relation #戦国時代の関係性
	attr_accessor :b1, :b2, :r
    def initialize(b1,b2,relation) #武家1,武家2,関係性
        @b1 = Sengoku_buke.new(b1)
        @b2 = Sengoku_buke.new(b2)
        @r = relation
    end
end

class Sengoku_buke #戦国時代の武家情報
	attr_accessor :buke, :ido, :keido
    def initialize(buke)#武家,緯度,経度
    	h = data1562()
    	for temp in h
			if buke == temp[0]
		        @buke = temp[0]
	            @ido = temp[1]
		        @keido = temp[2]
			end
    	end
    end
end

class ArgGraph
	def initialize
	end
    def show_allgraph #すべての武家の関係を表示
        graph = open("sengoku.dot", "w") #dotファイルを生成する、dot -Tpng sengoku_surround.dot -o sengoku_surround.png と叩くとpng形式で出力できる
        graph.print "digraph G{\n"
        graph.print "layout = neato;\n"
        for sengoku in $DATA1562
        	i = (sengoku.ido - 31) * 1.8 #見やすく調整した
        	k = (sengoku.keido - 129.9) * 1.4
        	graph.print sengoku.buke ," [pos = \"", k ,"," , i ,"!\", shape = box, fixedsize = true, width = 1.1, height = 0.25] ; \n"
        end
        for sengoku_r in $DATA1562_RELATION
        	if sengoku_r.r == "+"
        		graph.print sengoku_r.b1.buke ," -> ", sengoku_r.b2.buke, 
        		"[label=\"", sengoku_r.r,"\",fontcolor = blue, color = blue, dir = none, style = bold] ; \n"
        	else
        		graph.print sengoku_r.b1.buke ," -> ", sengoku_r.b2.buke, 
        		"[label=\"", sengoku_r.r,"\",fontcolor = red, color = red, dir = none, style = bold] ; \n"
        	end
		end
		graph.print "}\n"
		graph.close
    end
    
    def show_surround(name) #ある武家Aの周辺のみ表示
        graph = open("sengoku_surround.dot", "w")
        graph.print "digraph G{\n"
        graph.print "layout = neato;\n"
    	for sengoku in $DATA1562
			if name == sengoku.buke #ある武家Aの画像での位置
		        i_0 = (sengoku.ido - 31) * 1.8
				k_0 = (sengoku.keido - 129.9) * 1.4
			end
		end
        for sengoku in $DATA1562 #すべての武家で
			i = (sengoku.ido - 31) * 1.8 
	        k = (sengoku.keido - 129.9) * 1.4
			distance = ( (i - i_0) ** 2 + (k - k_0) ** 2 ) ** (1.0 / 2.0) #武家aとの距離
			if distance < 3 #近ければグラフに書く
	        	graph.print sengoku.buke ," [pos = \"", k ,"," , i ,"!\", shape = box, fixedsize = true, width = 1.1, height = 0.25] ; \n"
	        end
	    end
        for sengoku_r in $DATA1562_RELATION #関係性も近くにある国のみ描く
			if sengoku_r.b1.buke == name
				i_2 = (sengoku_r.b2.ido - 31) * 1.8
	        	k_2 = (sengoku_r.b2.keido - 129.9) * 1.4
	        	distance = ( (i_2 - i_0) ** 2 + (k_2 - k_0) ** 2 ) ** (1.0 / 2.0)
				if distance < 3
		        	if sengoku_r.r == "+"
		        		graph.print sengoku_r.b1.buke ," -> ", sengoku_r.b2.buke, 
		        		"[label=\"", sengoku_r.r,"\",fontcolor = blue, color = blue, dir = none, style = bold] ; \n"
		        	else
		        		graph.print sengoku_r.b1.buke ," -> ", sengoku_r.b2.buke, 
		        		"[label=\"", sengoku_r.r,"\",fontcolor = red, color = red, dir = none, style = bold] ; \n"
		        	end
		        end
		    elsif sengoku_r.b2.buke == name
				i_2 = (sengoku_r.b1.ido - 31) * 1.8
	        	k_2 = (sengoku_r.b1.keido - 129.9) * 1.4
	        	distance = ( (i_2 - i_0) ** 2 + (k_2 - k_0) ** 2 ) ** (1.0 / 2.0)
		    	if sengoku_r.r == "+"
			        graph.print sengoku_r.b1.buke ," -> ", sengoku_r.b2.buke,
			        "[label=\"", sengoku_r.r,"\",fontcolor = blue, color = blue, dir = none, style = bold] ; \n"
			    else
			        graph.print sengoku_r.b1.buke ," -> ", sengoku_r.b2.buke, 
		    	    "[label=\"", sengoku_r.r,"\",fontcolor = red, color = red, dir = none, style = bold] ; \n"
		        end
		    end
		end
		graph.print "}\n"
		graph.close
		print "show graph around " , name , "\n"
    end

    def relation(buke_a,buke_b) #武家aと武家bの関係
		for  sengoku_r in $DATA1562_RELATION
			if ( sengoku_r.b1.buke == buke_a && sengoku_r.b2.buke == buke_b ) || ( sengoku_r.b1.buke == buke_b && sengoku_r.b2.buke == buke_a ) then  
			#2国がすでに関係が示されているかどうかを見る
				print "relation between " , buke_a , " and " , buke_b ," is " , sengoku_r.r , "\n"
				return
			end
		end
		desition_yuukou = 0 
		#a国とb国の関係が同盟国の同盟国or敵対国の敵対国で、友好であるとすることができる国の数
		desition_tekitai = 0 #同盟国の敵対国で敵対になりえる数
		for  sengoku in $DATA1562 #国ごとに考えていく
			count = 0 #カウンター変数初期化
			rel = Array.new(2, 0) #関係を見る用、初期化
			if sengoku.buke != buke_a && sengoku.buke != buke_b #他国との関係を見る
				for i in 0..$DATA1562.length() - 1 #関係を全て見る
					if data1562_relation[i][0] == sengoku.buke || data1562_relation[i][1] == sengoku.buke #ある他国が
						if data1562_relation[i][0] == buke_a || data1562_relation[i][1] == buke_a || data1562_relation[i][0] == buke_b || data1562_relation[i][1] == buke_b then #武家a若しくはbと関係を持つ場合
							if data1562_relation[i][2] == "+"
								rel[count] = 1
							count += 1
							else
								rel[count] = -1
							count += 1
							end
						end
					end
				end
			end
			result = rel[0] * rel[1]
			#同盟を1,敵対を-1にしたので上記の関係を満たすには掛け算で良い
			if result == 1
				desition_yuukou += 1
			elsif result == -1
				desition_tekitai += 1
			end
		end
		if desition_yuukou > desition_tekitai
			print "relation between " , buke_a , " and " , buke_b ," is + \n"
		elsif desition_yuukou < desition_tekitai
			print "relation between " , buke_a , " and " , buke_b ," is - \n"
		else
			print "relation between " , buke_a , " and " , buke_b ," is flat \n"
		end
    end

    def isolation(name) #孤立しているかどうかの判定
    	for sengoku in $DATA1562
			if name == sengoku.buke #ある武家Aの画像での位置
		        i_0 = (sengoku.ido - 31) * 1.8
				k_0 = (sengoku.keido - 129.9) * 1.4
			end
		end
		enemy = 0 #敵の数
        for sengoku_r in $DATA1562_RELATION 
			if sengoku_r.b1.buke == name 
				i_2 = (sengoku_r.b2.ido - 31) * 1.8
	        	k_2 = (sengoku_r.b2.keido - 129.9) * 1.4
	        	distance = ( (i_2 - i_0) ** 2 + (k_2 - k_0) ** 2 ) ** (1.0 / 2.0)
				if distance < 3 #近くにある国のみで考える
		        	if sengoku_r.r == "+"
						print name , " is not isolated \n"
						return
		        	else
		        		enemy += 1
		        	end
		        end
		    elsif sengoku_r.b2.buke == name
				i_2 = (sengoku_r.b1.ido - 31) * 1.8
	        	k_2 = (sengoku_r.b1.keido - 129.9) * 1.4
	        	distance = ( (i_2 - i_0) ** 2 + (k_2 - k_0) ** 2 ) ** (1.0 / 2.0)
				if distance < 3 #近くにある国のみで考える
		        	if sengoku_r.r == "+"
						print name , " is not isolated \n"
						return
		        	else
		        		enemy += 1
		        	end
		        end
		    end
		end
		if enemy > 0
			print name , " is isolated \n"
		else
			print name , " is not isolated, but there is not an ally around \n"
		end
    end
end



$DATA1562 = [] #武家の名前のみでクラスを付ける
$DATA1562_RELATION = [] #武家の関係性にクラスを付ける

#戦国時代の1562年のデータ
#参考、http://www.geocities.jp/seiryokuzu/c1562.jpg(ただし同盟関係などが調べて分かるもののみ抽出)
#経度緯度はグーグルマップで
def data1562
	data1562 =[
    ["nanbu",40.659591,140.993408],
    ["andou",40.006362,140.262817],
    ["tozawa",39.913732,140.751709],
    ["kasai",39.261812,141.625122],
    ["oosaki",38.698151,140.801147],
    ["mogami",38.526460,140.317749],
    ["date",37.735745,140.136475],
    ["souma",37.413575,140.867065],
    ["ashina",37.422301,139.905762],
    ["uesugi",37.343734,138.856567],
    ["satake",36.451989,140.356201],
    ["satomi",35.133155,139.960693],
    ["houzyou",35.406730,139.257568],
    ["takeda",36.146518,137.900757],
    ["imagawa",35.034262,138.076538],
    ["honganzi",36.491745,136.604370],
    ["tokugawa",34.944255,137.192139],
    ["oda",35.178066,136.917480],
    ["saitou",35.420160,136.791138],
    ["asakura",36.026660,136.384644],
    ["azai",35.438064,136.296753], #あさいではなくあざい
    ["rokkaku",34.980270,136.022095],
    ["matunaga",34.188851,135.868286],
    ["kitabatake",34.465572,136.494507],
    ["hatakeyama",33.929452,135.417847], 
    ["yamana",35.545405,134.736694],
    ["ukita",34.691711,134.022583],
    ["amago",35.361945,133.077759],
    ["mouri",34.651052,132.369141],
    ["miyoshi",34.038770,134.330200],
    ["kouno",33.920336,132.967896],
    ["tyousokabe",33.559470,133.533691],
    ["itizyou",32.916247,132.885498],
    ["ootomo",33.238450,130.979370],
    ["ryuuzouzi",33.266013,130.364136],
    ["arima",33.137314,129.924683],
    ["sara",32.351883,130.605835],
    ["itou",32.231150,131.336426],
    ["shimazu",31.597011,130.704712]
	]
end

#同盟関係,敵対関係
#参考：信長の野望 天翔記
def data1562_relation 
	data1562_relation = [
	["tozawa","nanbu","-"],
	["tozawa","andou","-"],
	["ashina","kasai","-"],
	["date","kasai","-"],
	["date","oosaki","+"],
	["date","ashina","+"],
	["date","souma","-"],
	["date","mogami","+"],
	["date","satake","+"],
	["souma","ashina","-"],
	["mogami","oosaki","+"],
	["oosaki","kasai","-"],
	["nanbu","andou","-"],
	["satomi","houzyou","-"],
	["satomi","uesugi","+"],
	["ashina","satake","-"],
	["ashina","houzyou","+"],
	["ashina","takeda","+"],
	["souma","satake","-"],
	["houzyou","imagawa","+"],
	["houzyou","uesugi","-"],
	["houzyou","honganzi","+"],
	["houzyou","takeda","+"],
	["takeda","uesugi","-"],
	["takeda","imagawa","+"],
	["takeda","satake","+"],
	["takeda","honganzi","+"],
	["uesugi","ashina","+"],
	["uesugi","hatakeyama","+"],
	["uesugi","asakura","+"],
	["uesugi","honganzi","-"],
	["oda","imagawa","-"],
	["tokugawa","imagawa","-"],
	["oda","tokugawa","+"],
	["oda","saitou","-"],
	["oda","kitabatake","+"],
	["honganzi","asakura","-"],
	["oda","asakura","-"],
	["azai","asakura","+"],
	["saitou","asakura","-"],
	["azai","rokkaku","-"],
	["rokkaku","asakura","-"],
	["rokkaku","miyoshi","-"],
	["rokkaku","hatakeyama","+"],
	["hatakeyama","honganzi","-"],
	["hatakeyama","miyoshi","-"],
	["hatakeyama","kitabatake","+"],
	["yamana","miyoshi","-"],
	["yamana","amago","-"],
	["yamana","mouri","+"],
	["kouno","miyoshi","-"],
	["kouno","mouri","+"],
	["kouno","tyousokabe","-"],
	["mouri","amago","-"],
	["mouri","ootomo","-"],
	["mouri","ryuuzouzi","+"],
	["miyoshi","itizyou","-"],
	["ootomo","itizyou","+"],
	["ootomo","ryuuzouzi","-"],
	["ootomo","sara","-"],
	["ootomo","itou","-"],
	["ryuuzouzi","arima","-"],
	["tyousokabe","itizyou","-"],
	["itou","shimazu","-"],
	["sara","shimazu","-"],
	["matunaga","oda","+"],
	["matunaga","tokugawa","+"],
	["matunaga","takeda","-"],
	["matunaga","uesugi","-"],
	["matunaga","hatakeyama","-"],
	["matunaga","asakura","-"],
	["matunaga","azai","-"],
	["matunaga","honganzi","-"],
	["matunaga","miyoshi","-"],
	["matunaga","amago","-"],
	["matunaga","ukita","-"],
	["matunaga","mouri","-"],
	["matunaga","kouno","-"],
	["ukita","yamana","-"],
	["ukita","amago","-"],
	["ukita","mouri","+"],
	["takeda","tokugawa","-"],
	["tokugawa","asakura","-"],
	["tokugawa","honganzi","-"]
	]
end


def main()
	for i in 0.. data1562.length() - 1
		$DATA1562[i] = Sengoku_buke.new(data1562[i][0])
	end
	for j in 0.. data1562_relation.length() - 1
		$DATA1562_RELATION[j] = Sengoku_relation.new(data1562_relation[j][0],data1562_relation[j][1],data1562_relation[j][2])
	end
	a = ArgGraph.new()
    a.show_allgraph
    a.show_surround("miyoshi")
    a.isolation("miyoshi")
    a.isolation("matunaga")
	a.relation("oda","tokugawa")
    a.relation("oda","houzyou")
    a.relation("tokugawa","uesugi")
    a.relation("nanbu", "shimazu")
end

main()
