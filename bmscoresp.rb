# -*- coding: utf-8 -*-


Plugin.create(:bmscoresp) do


	command(
		:bmscoresp,
		name: 'beatmaniaの譜面に変換',
		condition: lambda{ |opt| true },
		visible: true,
		role: :postbox
		) do |opt|

		def let2scr1p (letter, judge, allscr)
			notes = "　｜┥┝┿━"
			score = ""
			if allscr == true
				allscr_notes = 0
				8.times do |i|
					if Regexp.new(["s", "1", "2", "3", "4", "5", "6", "7"][i]) =~ letter
						allscr_notes += 1
					end
				end
				aspattern = ["s"] + ["1", "2", "3", "4", "5", "6", "7"].shuffle!
				letter = ""
				allscr_notes.times do |i|
					letter += aspattern[i]
				end
			end
			8.times do |i|
				if Regexp.new(judge[i]) =~ letter
					judge[i] = "1"
				else
					judge[i] = "0"
				end
			end
			judge += "0"
			if judge[0] == "0"
				score += notes[1] + notes[0]
			else
				score += notes[3] + notes[5]
			end
			8.times do |i|
				if judge[i] == "0"
					if judge[i + 1] == "0"
						score += notes[1]
					else
						score += notes[3]
					end
				else
					if judge[i + 1] == "0"
						score += notes[2]
					else
						score += notes[4]
					end
				end
			end
			score += "\n"
			return score
		end

		def let2scr2p (letter, judge, allscr)
			notes = "　｜┥┝┿━"
			score = ""
			if allscr == true
				allscr_notes = 0
				8.times do |i|
					if Regexp.new(["1", "2", "3", "4", "5", "6", "7", "s"][i]) =~ letter
						allscr_notes += 1
					end
				end
				aspattern = ["s"] + ["1", "2", "3", "4", "5", "6", "7"].shuffle!
				letter = ""
				allscr_notes.times do |i|
					letter += aspattern[i]
				end
				letter = letter.split("").rotate(1).join("")
			end
			8.times do |i|
				if Regexp.new(judge[i]) =~ letter
					judge[i] = "1"
				else
					judge[i] = "0"
				end
			end
			judge = "0" + judge
			8.times do |i|
				if judge[i] == "0"
					if judge[i + 1] == "0"
						score += notes[1]
					else
						score += notes[3]
					end
				else
					if judge[i + 1] == "0"
						score += notes[2]
					else
						score += notes[4]
					end
				end
			end
			if judge[8] == "0"
				score += notes[0] + notes[1]
			else
				score += notes[5] + notes[2]
			end
			score += "\n"
			return score
		end


		n = 0
		side = 1
		tweet = ""
		ran = ["1", "2", "3", "4", "5", "6", "7"]
		alls = false
		sran = false
		before = Plugin.create(:gtk).widgetof(opt.widget).widget_post.buffer.text.split(" ").reverse!


		if Regexp.new("-") =~ before[before.size - 1]

			if Regexp.new("2") =~ before[before.size - 1] # 2P SIDE
				side = 2
			end

			if Regexp.new("scr") =~ before[before.size - 1] # ALL-SCR
				alls = true
			elsif Regexp.new("sr") =~ before[before.size - 1] # S-RANDOM
				sran = true
			elsif Regexp.new("rr") =~ before[before.size - 1] # R-RANDOM
				ran = ran.rotate(rand(1..6))
				if rand(0..1) == 0
					ran.reverse!
				end
			elsif Regexp.new("r") =~ before[before.size - 1] # RANDOM
				while ran == ["1", "2", "3", "4", "5", "6", "7"] do
					ran.shuffle!
				end
			elsif Regexp.new("m") =~ before[before.size - 1] # MIRROR
				ran.reverse!
			end
			before.delete_at(-1)
		end

		while before[n] != nil
			if sran == true
				ran.shuffle!
			end
			if side == 1
				juds = "s" + ran.join('')
				tweet += let2scr1p(before[n], juds, alls)
			else
				juds = ran.join('') + "s"
				tweet += let2scr2p(before[n], juds, alls)
			end
			n += 1
		end
		Plugin.create(:gtk).widgetof(opt.widget).widget_post.buffer.text = tweet.reverse![0..139].reverse!
	end
end
