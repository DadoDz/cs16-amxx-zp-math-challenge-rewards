#include <amxmodx>

#define PLUGIN "[ZP] Math Challenge Rewards"
#define VERSION "1.0"
#define AUTHOR "DadoDz"

native zp_get_user_packs(index);
native zp_set_user_packs(index, packs);

#define TASK_START 1000
#define TASK_END 2000

#define RESTART_TIME 150.0
#define ANSWER_TIME 20.0

new bool:MathProblem;
new MathAnswer[10], Question[250];
new Float:MathStartTime;
new WrongTries[33];

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)

    register_clcmd("say", "client_say")

    set_task(RESTART_TIME, "MathProblems", TASK_START, _, _, "", 0)
}

public client_say(id)
{
    if (!MathProblem || !is_user_connected(id))
        return PLUGIN_CONTINUE;

    if (WrongTries[id] >= 3)
    {
        client_print_color(id, 0, "^x04[^x01ZP^x04]^x01 You have^x03 failed^x01 3 times^x04.^x01 You can't answer this^x03 question^x01 anymore.");
        return PLUGIN_HANDLED;
    }

    static PlayerAnswer[10];
    read_args(PlayerAnswer, sizeof(PlayerAnswer));
    remove_quotes(PlayerAnswer);

    // Correct answer
    if (equal(MathAnswer, PlayerAnswer))
    {
        MathProblem = false;
        new PlayerName[64];
        get_user_name(id, PlayerName, sizeof(PlayerName));

        new PacksReward;
        if (((get_gametime() - MathStartTime) / ANSWER_TIME) < 1.0)
            PacksReward = floatround(50 * (1.0 - (get_gametime() - MathStartTime) / ANSWER_TIME));
        else
            PacksReward = 0;

        zp_set_user_packs(id, zp_get_user_packs(id) + PacksReward);

        set_hudmessage(0, 255, 100, 0.02, 0.70, 0, 0.0, 3.5, 0.1, 0.25);
        show_hudmessage(0, "• %s has saved the math problem and won %d packs •", PlayerName, PacksReward);
        client_print_color(0, 0, "^x04[^x01ZP^x04]^x03 %s^x01 has saved the^x03 math problem^x01 and won^x04 %d^x01 packs^x03!", PlayerName, PacksReward);

        MathStartTime = 0.0;
        remove_task(TASK_END);
        remove_task(TASK_START);
        set_task(RESTART_TIME, "MathProblems", TASK_START, _, _, "", 0);
    }
    else
    {
        WrongTries[id]++;
        client_print_color(id, 0, "^x04[^x01ZP^x04]^x01 Wrong answer! Tries left:^x03 %d", 3 - WrongTries[id]);

        if (WrongTries[id] >= 3)
            client_print_color(id, 0, "^x04[^x01ZP^x04]^x01 You have reached the^x03 maximum^x01 tries for this^x03 challenge^x01.");
    }

    return PLUGIN_HANDLED;
}

public MathProblems()
{
    new question_1[250], question_2[250];
    new answer, answer_1, answer_2;
    new number_1, number_2, number_3, number_4;

    switch (random_num(0 , 2))
    {
        case 0:
        {
            switch (random_num(0 , 4)) 
            {
                case 0: // "+"
                {
                    number_1 = random_num(0 , 100)
                    number_2 = random_num(0 , 50)

                    answer = number_1 + number_2;
                    formatex(Question, sizeof(Question), "%i + %i = ?", number_1, number_2)
                }
                case 1: // "-"
                {
                    number_1 = random_num(0 , 100)
                    number_2 = random_num(0 , 50)

                    answer = number_1 - number_2;
                    formatex(Question, sizeof(Question), "%i - %i = ?", number_1, number_2)
                }
                case 2: // "*"
                {
                    number_1 = random_num(0 , 50)
                    number_2 = random_num(0 , 25)

                    answer = number_1 * number_2;
                    formatex(Question, sizeof(Question), "%i x %i = ?", number_1, number_2)
                }
                case 3: // "/"
                {
                    number_1 = random_num(0 , 50)
                    number_2 = random_num(0 , 25)

                    if(number_1 == 0)
                        number_2 = 1
                    else
                    {
                        number_2 = random_num(1, number_1)

                        while (number_1 % number_2 != 0)
                            number_2 = random_num(1, number_1)
                    }

                    answer = number_1 / number_2
                    formatex(Question, sizeof(Question), "%i / %i = ?", number_1, number_2)
                }
                case 4: // "!"
                {
                    number_1 = random_num(0 , 7)
                    answer = 1

                    for(new i = 1; i <= number_1; i++)
                        answer *= i

                    formatex(Question, sizeof(Question), "%i! = ?", number_1)
                }
            }
        }
        case 1:
        {
            switch (random_num(0 , 3)) 
            {
                case 0: // "+"
                {
                    number_1 = random_num(0 , 100)
                    number_2 = random_num(0 , 50)

                    answer = number_1 + number_2
                    formatex(question_1, sizeof(question_1), "%i + %i", number_1, number_2)
                }
                case 1: // "-"
                {
                    number_1 = random_num(0 , 100)
                    number_2 = random_num(0 , 50)

                    answer = number_1 - number_2
                    formatex(question_1, sizeof(question_1), "%i - %i", number_1, number_2)
                }
                case 2: // "*"
                {
                    number_1 = random_num(0 , 25)
                    number_2 = random_num(0 , number_2 / 2)

                    answer = number_1 * number_2
                    formatex(question_1, sizeof(question_1), "%i x %i", number_1, number_2)
                }
                case 3: // "/"
                {
                    number_1 = random_num(0 , 25)
                    number_2 = random_num(0 , number_2 / 2)

                    if(number_1 == 0)
                        number_2 = 1
                    else
                    {
                        number_2 = random_num(1, number_1)

                        while (number_1 % number_2 != 0)
                            number_2 = random_num(1, number_1)
                    }

                    answer = number_1 / number_2
                    formatex(question_1, sizeof(question_1), "%i / %i", number_1, number_2)
                }
            }
    
            switch (random_num(0 , 3)) 
            {
                case 0: // "+"
                {
                    number_3 = random_num(0 , 50)

                    answer += number_3
                    formatex(Question, sizeof(Question), "(%s) + %i = ?", question_1, number_3)
                }
                case 1: // "-"
                {
                    number_3 = random_num(0 , 50) 

                    answer -= number_3
                    formatex(Question, sizeof(Question), "(%s) - %i = ?", question_1, number_3)
                }
                case 2: // "*"
                {
                    number_3 = random_num(0 , 25 / 2)

                    answer *= number_3
                    formatex(Question, sizeof(Question), "(%s) x %i = ?", question_1, number_3)
                }
                case 3: // "/"
                {
                    number_3 = random_num(0 , 25 / 2)

                    if(answer == 0)
                        number_3 = 1
                    else
                    {
                        number_3 = random_num(1, 25 / 2)

                        while (answer % number_3 != 0)
                            number_3 = random_num(1, 25 / 2)
                    }

                    answer /= number_3
                    formatex(Question, sizeof(Question), "(%s) / %i = ?", question_1, number_3)
                }
            }
        }
        case 2:
        {
            REMAKE:switch (random_num(0 , 3)) 
            {
                case 0: // "+"
                {
                    number_1 = random_num(0 , 50)
                    number_2 = random_num(0 , 25)

                    answer_1 = number_1 + number_2
                    formatex(question_1, sizeof(question_1), "%i + %i", number_1, number_2)
                }
                case 1: // "-"
                {
                    number_1 = random_num(0 , 50)
                    number_2 = random_num(0 , 25)

                    answer_1 = number_1 - number_2
                    formatex(question_1, sizeof(question_1), "%i - %i", number_1, number_2)
                }
                case 2: // "*"
                {
                    number_1 = random_num(0 , 10)
                    number_2 = random_num(0 , 5)

                    answer_1 = number_1 * number_2
                    formatex(question_1, sizeof(question_1), "%i x %i", number_1, number_2)
                }
                case 3: // "/"
                {
                    number_1 = random_num(0 , 10)
                    number_2 = random_num(0 , 5)

                    if (number_1 == 0)
                        number_2 = 1
                    else
                    {
                        number_2 = random_num(1, number_1)

                        while (number_1 % number_2 != 0)
                            number_2 = random_num(1, number_1)
                    }

                    answer_1 = number_1 / number_2
                    formatex(question_1, sizeof(question_1), "%i / %i", number_1, number_2)
                }
            }

            switch (random_num(0 , 3)) 
            {
                case 0: // "+"
                {
                    number_3 = random_num(0 , 50)
                    number_4 = random_num(0 , 25)

                    answer_2 = number_3 + number_4
                    formatex(question_2, sizeof(question_2), "%i + %i", number_3, number_4)
                }
                case 1: // "-"
                {
                    number_3 = random_num(0 , 50)
                    number_4 = random_num(0 , 25)

                    answer_2 = number_3 - number_4
                    formatex(question_2, sizeof(question_2), "%i - %i", number_3, number_4)
                }
                case 2: // "*"
                {
                    number_3 = random_num(0 , 10)
                    number_4 = random_num(0 , 5)

                    answer_2 = number_3 * number_4
                    formatex(question_2, sizeof(question_2), "%i x %i", number_3, number_4)
                }
                case 3: // "/"
                {
                    number_3 = random_num(0 , 10)
                    number_4 = random_num(0 , 5)
                
                    if (number_3 == 0)
                        number_4 = 1
                    else
                    {
                        number_4 = random_num(1, number_3)

                        while (number_3 % number_4 != 0)
                            number_4 = random_num(1, number_3)
                    }

                    answer_2 = number_3 / number_4
                    formatex(question_2, sizeof(question_2), "%i / %i", number_3, number_4)
                }
            }

            switch (random_num(0 , 2)) 
            {
                case 0: // "+"
                {
                    answer = answer_1 + answer_2
                    formatex(Question, sizeof(Question), "(%s) + (%s) = ?", question_1, question_2)
                }
                case 1: // "-"
                {
                    answer = answer_1 - answer_2
                    formatex(Question, sizeof(Question), "(%s) - (%s) = ?", question_1, question_2)
                }
                case 2: // "*"
                {
                    answer = answer_1 * answer_2
                    formatex(Question, sizeof(Question), "(%s) x (%s) = ?", question_1, question_2)
                }
                case 3: // "/"
                {
                    if (answer_2 != 0 && answer_1 % answer_2 == 0)
                    {
                        answer = answer_1 / answer_2
                        formatex(Question, sizeof(Question), "(%s) / (%s) = ?", question_1, question_2)
                    }
                    else
                        goto REMAKE
                }
            }
        }
    }

    MathProblem = true;

    for (new id = 1; id <= get_maxplayers(); id++)
        WrongTries[id] = 0;

    MathStartTime = get_gametime();
    num_to_str(answer, MathAnswer, sizeof(MathAnswer))

    set_hudmessage(0, 150, 255, 0.02, 0.65, 0, 0.0, 7.5, 0.1, 0.25)
    show_hudmessage(0, "• Math Problem: %s •", Question)
    client_print_color(0, 0, "^x04[^x01ZP^x04]^x01 Math Problem^x03:^x04 %s", Question)
    
    set_task(ANSWER_TIME, "NoOneSolveProblem", TASK_END, _, _, "", 0)
}

public NoOneSolveProblem()
{
    if(MathProblem == true)
    {
        MathProblem = false;
        MathStartTime = 0.0;
        set_hudmessage(255, 50, 25, 0.02, 0.65, 0, 0.0, 10.0, 0.1, 0.25)
        show_hudmessage(0, "• No one solve the last problem^n• %s^n• The answer was %s", Question, MathAnswer)

        remove_task(TASK_END)
        remove_task(TASK_START)
        set_task(RESTART_TIME, "MathProblems", TASK_START, _, _, "", 0)
    }
}