class Game

    @@point_to_section_map = [
        [0,0,0,1,1,1,2,2,2],
        [0,0,0,1,1,1,2,2,2],
        [0,0,0,1,1,1,2,2,2],
        [3,3,3,4,4,4,5,5,5],
        [3,3,3,4,4,4,5,5,5],
        [3,3,3,4,4,4,5,5,5],
        [6,6,6,7,7,7,8,8,8],
        [6,6,6,7,7,7,8,8,8],
        [6,6,6,7,7,7,8,8,8],
        ]

    @@points_by_section_number = {
        0 => [],
        1 => [],
        2 => [],
        3 => [],
        4 => [],
        5 => [],
        6 => [],
        7 => [],
        8 => []
        }

    def initialize(grid) 
        @ruled_out_by_column = { # grid[*][column_number]
            0 => [],
            1 => [],
            2 => [],
            3 => [],
            4 => [],
            5 => [],
            6 => [],
            7 => [],
            8 => []
        }
       
        @ruled_out_by_row = {  # grid[row_number][*]
            0 => [],
            1 => [],
            2 => [],
            3 => [],
            4 => [],
            5 => [],
            6 => [],
            7 => [],
            8 => []
        }

        @ruled_out_by_section = {
            0 => [],
            1 => [],
            2 => [],
            3 => [],
            4 => [],
            5 => [],
            6 => [],
            7 => [],
            8 => []
        }

        @grid = grid
        generate_possibilities(grid)
    end

    def generate_possibilities grid
        generate_row_possibilities(grid)
        generate_column_possibilities(grid)
        generate_section_possibilities(grid)
    end

    def solve
        count = 1
        while !solved?
            raise "Couldn't solve puzzle :/" if count > 100
            [0,1,2,3,4,5,6,7,8].each do |num|
                solve_by_strict_elimination
                solve_by_row_elimination(num)
                solve_by_column_elimination(num)
                solve_by_section_elimination(num)
            end
            count += 1
        end
        puts pretty_grid
        puts "Sudoku Solved!"
        @grid
    end

    def solved?
        @grid.each do |row|
            if row.include? 0
                return false
            end
        end
        return true
    end

    def ruled_out_by_column
        @ruled_out_by_column
    end

    def ruled_out_by_row
        @ruled_out_by_row
    end

    def ruled_out_by_section
        @ruled_out_by_section
    end

    def points_by_section_number
        @@points_by_section_number
    end

    def grid
        @grid
    end

    def pretty_grid
        @grid.map { |x| x.join(' ') }
    end

    private

    # GENERATE POSSIBILITIES 

    def generate_row_possibilities grid
        possibilities = Marshal.load(Marshal.dump(grid))
        possibilities.each_with_index do |row, row_number|
            ruled_out_by_current_row = row.select{|x| x.is_a?(Numeric) && x != 0 }
            @ruled_out_by_row[row_number] = ruled_out_by_current_row
        end
    end


    def generate_column_possibilities grid
        char_index = 0
        while char_index < 9
            column_possibilities = [1,2,3,4,5,6,7,8,9]
            ruled_out = []
            row_index = 0
            while row_index < 9 
                ruled_out.push(grid[row_index][char_index]) if grid[row_index][char_index] != 0
                row_index += 1
            end
            @ruled_out_by_column[char_index] = ruled_out
            char_index += 1
        end
    end


    def generate_section_possibilities grid
        (0..8).each do |x|
            (0..8).each do |y|
                section_number = @@point_to_section_map[x][y]
                if grid[x][y] != 0
                    @ruled_out_by_section[section_number].push(grid[x][y]) 
                end
            end
        end
    end

    def generate_possibilities_for_a_point(x, y)
        possibilities = [1,2,3,4,5,6,7,8,9] - @ruled_out_by_row[x]
        possibilities = possibilities - @ruled_out_by_column[y]
        section_number = @@point_to_section_map[x][y]
        possibilities = possibilities - @ruled_out_by_section[section_number]
        return possibilities
    end


    def get_points_in_a_section(section_number)
        # this looks janky, but its actually a bit of lazy loading, which is pretty cool
        # it's very unlikely we'll never need to create this data, but it's an interesting implementation of a concept
        return @@points_by_section_number[section_number] unless @@points_by_section_number[section_number].empty?
        points = []
        @@point_to_section_map.each_with_index do |row, row_index|
            row.each_with_index do |point, column_index|
                if point === section_number
                    points.push([row_index, column_index])
                end
                if points.length == 9
                    @@points_by_section_number[section_number] = points
                    return points
                end
            end
        end
    end

    # SOLVEING

    def solve_by_strict_elimination
        (0..8).each do |y|
            (0..8).each do |x|
                if grid[x][y] == 0 
                    possibilities = generate_possibilities_for_a_point(x, y)
                    if possibilities.length == 1
                        grid[x][y] = possibilities[0]
                        @ruled_out_by_row[x].push(possibilities[0])
                        @ruled_out_by_column[y].push(possibilities[0])
                        section_number = @@point_to_section_map[x][y]
                        @ruled_out_by_section[section_number].push(possibilities[0])
                        return solve_by_strict_elimination
                    end
                end
            end
        end
        return false
    end

    def solve_by_row_elimination(x)
        remaining_numbers = [1,2,3,4,5,6,7,8,9] - @ruled_out_by_row[x]
        if remaining_numbers.empty?
            return true
        end
        remaining_numbers.each do |remaining_number|
            possible_y = []
            [0,1,2,3,4,5,6,7,8].each do |y|
                break if possible_y.length > 1
                if @grid[x][y] == 0
                    possibilities = generate_possibilities_for_a_point(x, y)
                    possible_y.push(y) if possibilities.include? remaining_number
                end
            end
            if possible_y.length == 1
                @grid[x][possible_y[0]] = remaining_number
                
                @ruled_out_by_row[x].push(remaining_number)
                @ruled_out_by_column[possible_y[0]].push(remaining_number)
                section_number = @@point_to_section_map[x][possible_y[0]]
                @ruled_out_by_section[section_number].push(remaining_number)
                return solve_by_row_elimination(x)
            end
        end
        false
    end

    def solve_by_column_elimination(y)
        remaining_numbers = [1,2,3,4,5,6,7,8,9] - @ruled_out_by_row[y]
        if remaining_numbers.empty?
            return true
        end

        remaining_numbers.each do |remaining_number|
            possible_x = []
            [0,1,2,3,4,5,6,7,8].each do |x|
                break if possible_x.length > 1 
                if @grid[x][y] == 0
                    possibilities = generate_possibilities_for_a_point(x, y)
                    possible_x.push(x) if possibilities.include? remaining_number
               end
            end
            if possible_x.length == 1
                @grid[possible_x[0]][y] = remaining_number
                @ruled_out_by_row[possible_x[0]].push(remaining_number)
                @ruled_out_by_column[y].push(remaining_number)
                section_number = @@point_to_section_map[possible_x[0]][y]
                @ruled_out_by_section[section_number].push(remaining_number)
                return solve_by_column_elimination(y)
            end
        end
        false
    end

    def solve_by_section_elimination(section_number)    
        remaining_numbers = [1,2,3,4,5,6,7,8,9] - @ruled_out_by_section[section_number]
        return true if remaining_numbers.empty?
        get_points_in_a_section(section_number) if @@points_by_section_number[section_number].empty?
        remaining_numbers.each do |remaining_number|
            possible_points = []
            @@points_by_section_number[section_number].each do |point|
                break if possible_points.length > 1
                if @grid[point[0]][point[1]] == 0
                    possibilities = generate_possibilities_for_a_point(point[0], point[1])
                    possible_points.push(point) if possibilities.include? remaining_number
                end
            end
            if possible_points.length == 1
                point = possible_points[0]
                @grid[point[0]][point[1]] = remaining_number
                @ruled_out_by_section[section_number].push(remaining_number)
                @ruled_out_by_row[point[0]].push(remaining_number)
                @ruled_out_by_column[point[1]].push(remaining_number)
                return solve_by_section_elimination(section_number)
            end
        end
        false
    end
end

# game = Game.new([
#     [0,0,2,0,0,0,0,3,4],
#     [0,6,4,2,0,0,5,0,0],
#     [8,0,0,0,7,5,0,0,0],
#     [0,0,7,0,4,0,0,5,1],
#     [0,0,0,0,9,8,0,0,3],
#     [1,0,0,0,0,0,2,0,0],
#     [0,4,0,0,0,3,0,8,0],
#     [3,5,0,6,0,0,4,0,0],
#     [0,0,0,0,1,0,0,9,7]
# ])

# game.solve



