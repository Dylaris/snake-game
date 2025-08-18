#include <iostream>
#include <deque>
#include <raylib.h>
#include <raymath.h>

static constexpr int cell_size = 32; // Equal to the width and height of 'food.png'
static constexpr int cell_count = 20;
static constexpr int offset = 50;

static constexpr Color green = {173, 204, 96, 255};
static constexpr Color dark_green = {43, 51, 24, 255};

static double last_update_time = 0;

static bool event_triggered(double internal)
{
    double current_time = GetTime();
    if (current_time - last_update_time >= internal) {
        last_update_time = current_time;
        return true;
    }
    return false;
}

static bool element_in_deque(Vector2 elem, std::deque<Vector2> queue)
{
    for (std::size_t i = 0; i < queue.size(); i++) {
        if (Vector2Equals(queue[i], elem)) return true;
    }
    return false;
}

struct Snake {
    std::deque<Vector2> body = {Vector2{6, 9}, Vector2{5, 9}, Vector2{4, 9}};
    Vector2 direction = {1, 0};
    bool add_segment = false;

    void draw()
    {
        for (std::size_t i = 0; i < body.size(); i++) {
            float x = body[i].x;
            float y = body[i].y;
            Rectangle segment = Rectangle{
                                    offset+x*cell_size, offset+y*cell_size, 
                                    cell_size, cell_size};
            DrawRectangleRounded(segment, 0.5, 6, dark_green);
        }
    }

    void update()
    {
        body.push_front(Vector2Add(body[0], direction));
        if (add_segment) {
            add_segment = false;
        } else {
            body.pop_back();
        }
    }
    
    void reset()
    {
        body = {Vector2{6, 9}, Vector2{5, 9}, Vector2{4, 9}};
        direction = {1, 0};
    }
};

struct Food {
    Vector2 position = {5, 6};
    Texture2D texture;

    Food(std::deque<Vector2> snake_body)
    {
        Image image = LoadImage("assets/food.png");
        texture = LoadTextureFromImage(image);
        UnloadImage(image);
        position = generate_random_pos(snake_body);
    }

    void draw()
    {
        DrawTexture(texture, offset+cell_size*position.x, 
                offset+cell_size*position.y, WHITE);
    }

    Vector2 generate_random_cell()
    {
        float x = GetRandomValue(0, cell_count-1);
        float y = GetRandomValue(0, cell_count-1);
        return Vector2{x, y};
    }

    Vector2 generate_random_pos(std::deque<Vector2> snake_body)
    {
        Vector2 position = generate_random_cell();
        while (element_in_deque(position, snake_body)) {
            position = generate_random_cell();
        }
        return position;
    }
};

struct Game {
    Snake snake = Snake();
    Food food = Food(snake.body);
    bool running = true;
    int score = 0;
    Sound eat_sound;
    Sound over_sound;

    Game()
    {
        InitAudioDevice();
        eat_sound = LoadSound("assets/eat.mp3");
        over_sound = LoadSound("assets/over.mp3");
    }

    void draw()
    {
        ClearBackground(green);
        DrawRectangleLinesEx(
                Rectangle{
                    (float)offset - 5,
                    (float)offset - 5,
                    (float)cell_size*cell_count + 10,
                    (float)cell_size*cell_count + 10
                }, 5, dark_green);
        DrawText("Snake Game", offset - 5, 0, 40, dark_green);
        DrawText(TextFormat("socre: %i", score), offset - 5, 
                cell_count*cell_size+offset+10, 30, dark_green);
        food.draw();
        snake.draw();
    }

    void listen()
    {
        if (IsKeyPressed(KEY_UP) && snake.direction.y != 1) {
            snake.direction = {0, -1};
            running = true;
        }
        if (IsKeyPressed(KEY_DOWN) && snake.direction.y != -1) {
            snake.direction = {0, 1};
            running = true;
        }
        if (IsKeyPressed(KEY_LEFT) && snake.direction.x != 1) {
            snake.direction = {-1, 0};
            running = true;
        }
        if (IsKeyPressed(KEY_RIGHT) && snake.direction.x != -1) {
            snake.direction = {1, 0};
            running = true;
        }
    }

    void update()
    {
        if (!running) return;
        snake.update();
        check_collision_with_food();
        check_collision_with_edges();
        check_collision_with_tail();
    }

    void check_collision_with_food()
    {
        if (Vector2Equals(snake.body[0], food.position)) {
            food.position = food.generate_random_pos(snake.body);
            snake.add_segment = true;
            score++;
            PlaySound(eat_sound);
        }
    }

    void check_collision_with_edges()
    {
        if ((snake.body[0].x == cell_count || snake.body[0].x == -1) ||
            (snake.body[0].y == cell_count || snake.body[0].y == -1)) {
            over();
        }
    }

    void check_collision_with_tail()
    {
        std::deque<Vector2> headless_body = snake.body;
        headless_body.pop_front();
        if (element_in_deque(snake.body[0], headless_body)) over();
    }

    void over()
    {
        snake.reset();
        food.position = food.generate_random_pos(snake.body);
        running = false;
        score = 0;
        PlaySound(over_sound);
    }
};

int main(void)
{
    InitWindow(2*offset+cell_size*cell_count,
               2*offset+cell_size*cell_count,
               "My Snake Game");
    SetTargetFPS(60);

    Game game = Game();

    while (!WindowShouldClose()) {
        BeginDrawing();

        // Updating
        if (event_triggered(0.2)) game.update();
        game.listen();

        // Drawing
        game.draw();

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
