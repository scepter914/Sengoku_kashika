class Sengoku_relation #�퍑����̊֌W��
	attr_accessor :b1, :b2, :r
    def initialize(b1,b2,relation) #����1,����2,�֌W��
        @b1 = Sengoku_buke.new(b1)
        @b2 = Sengoku_buke.new(b2)
        @r = relation
    end
end

class Sengoku_buke #�퍑����̕��Ə��
	attr_accessor :buke, :ido, :keido
    def initialize(buke)#����,�ܓx,�o�x
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
    def show_allgraph #���ׂĂ̕��Ƃ̊֌W��\��
        graph = open("sengoku.dot", "w") #dot�t�@�C���𐶐�����Adot -Tpng sengoku_surround.dot -o sengoku_surround.png �ƒ@����png�`���ŏo�͂ł���
        graph.print "digraph G{\n"
        graph.print "layout = neato;\n"
        for sengoku in $DATA1562
        	i = (sengoku.ido - 31) * 1.8 #���₷����������
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
    
    def show_surround(name) #���镐��A�̎��ӂ̂ݕ\��
        graph = open("sengoku_surround.dot", "w")
        graph.print "digraph G{\n"
        graph.print "layout = neato;\n"
    	for sengoku in $DATA1562
			if name == sengoku.buke #���镐��A�̉摜�ł̈ʒu
		        i_0 = (sengoku.ido - 31) * 1.8
				k_0 = (sengoku.keido - 129.9) * 1.4
			end
		end
        for sengoku in $DATA1562 #���ׂĂ̕��Ƃ�
			i = (sengoku.ido - 31) * 1.8 
	        k = (sengoku.keido - 129.9) * 1.4
			distance = ( (i - i_0) ** 2 + (k - k_0) ** 2 ) ** (1.0 / 2.0) #����a�Ƃ̋���
			if distance < 3 #�߂���΃O���t�ɏ���
	        	graph.print sengoku.buke ," [pos = \"", k ,"," , i ,"!\", shape = box, fixedsize = true, width = 1.1, height = 0.25] ; \n"
	        end
	    end
        for sengoku_r in $DATA1562_RELATION #�֌W�����߂��ɂ��鍑�̂ݕ`��
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

    def relation(buke_a,buke_b) #����a�ƕ���b�̊֌W
		for  sengoku_r in $DATA1562_RELATION
			if ( sengoku_r.b1.buke == buke_a && sengoku_r.b2.buke == buke_b ) || ( sengoku_r.b1.buke == buke_b && sengoku_r.b2.buke == buke_a ) then  
			#2�������łɊ֌W��������Ă��邩�ǂ���������
				print "relation between " , buke_a , " and " , buke_b ," is " , sengoku_r.r , "\n"
				return
			end
		end
		desition_yuukou = 0 
		#a����b���̊֌W���������̓�����or�G�΍��̓G�΍��ŁA�F�D�ł���Ƃ��邱�Ƃ��ł��鍑�̐�
		desition_tekitai = 0 #�������̓G�΍��œG�΂ɂȂ肦�鐔
		for  sengoku in $DATA1562 #�����Ƃɍl���Ă���
			count = 0 #�J�E���^�[�ϐ�������
			rel = Array.new(2, 0) #�֌W������p�A������
			if sengoku.buke != buke_a && sengoku.buke != buke_b #�����Ƃ̊֌W������
				for i in 0..$DATA1562.length() - 1 #�֌W��S�Č���
					if data1562_relation[i][0] == sengoku.buke || data1562_relation[i][1] == sengoku.buke #���鑼����
						if data1562_relation[i][0] == buke_a || data1562_relation[i][1] == buke_a || data1562_relation[i][0] == buke_b || data1562_relation[i][1] == buke_b then #����a�Ⴕ����b�Ɗ֌W�����ꍇ
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
			#������1,�G�΂�-1�ɂ����̂ŏ�L�̊֌W�𖞂����ɂ͊|���Z�ŗǂ�
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

    def isolation(name) #�Ǘ����Ă��邩�ǂ����̔���
    	for sengoku in $DATA1562
			if name == sengoku.buke #���镐��A�̉摜�ł̈ʒu
		        i_0 = (sengoku.ido - 31) * 1.8
				k_0 = (sengoku.keido - 129.9) * 1.4
			end
		end
		enemy = 0 #�G�̐�
        for sengoku_r in $DATA1562_RELATION 
			if sengoku_r.b1.buke == name 
				i_2 = (sengoku_r.b2.ido - 31) * 1.8
	        	k_2 = (sengoku_r.b2.keido - 129.9) * 1.4
	        	distance = ( (i_2 - i_0) ** 2 + (k_2 - k_0) ** 2 ) ** (1.0 / 2.0)
				if distance < 3 #�߂��ɂ��鍑�݂̂ōl����
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
				if distance < 3 #�߂��ɂ��鍑�݂̂ōl����
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



$DATA1562 = [] #���Ƃ̖��O�݂̂ŃN���X��t����
$DATA1562_RELATION = [] #���Ƃ̊֌W���ɃN���X��t����

#�퍑�����1562�N�̃f�[�^
#�Q�l�Ahttp://www.geocities.jp/seiryokuzu/c1562.jpg(�����������֌W�Ȃǂ����ׂĕ�������̂̂ݒ��o)
#�o�x�ܓx�̓O�[�O���}�b�v��
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
    ["azai",35.438064,136.296753], #�������ł͂Ȃ�������
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

#�����֌W,�G�Ί֌W
#�Q�l�F�M���̖�] �V�ċL
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
