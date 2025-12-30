#!/bin/bash

# ===================================================================
# A TUI promodoro timer.
# Made by: TRGR
# Dependancies:
#   - gum
#   - dunstify
# ===================================================================

# =======================
# Timer vars
# =======================

TIME_FOCUS=1500
TIME_SHORT_BREAK=300
TIME_LONG_BREAK=900

CYCLE=0

# --- CURSOR MANAGEMENT ---
hide_cursor() { printf "\033[?25l"; }
show_cursor() { printf "\033[?25h"; }
trap "show_cursor; exit" INT TERM EXIT

draw_bar() {
    local current=$1
    local total=$2
    local term_width=$(tput cols)
    local bar_width=$(( term_width * 50 / 100 ))
    [[ $bar_width -lt 15 ]] && bar_width=15 
    [[ $bar_width -gt 70 ]] && bar_width=70 
    
    local percentage=$((current * 100 / total))
    local filled=$((percentage * bar_width / 100))
    local empty=$((bar_width - filled))
    
    local filled_chars=$(printf '#%.0s' $(seq 1 $filled))
    local empty_chars=$(printf -- '-%.0s' $(seq 1 $empty))
    
    printf -- "[%s%s] %d%%" "$filled_chars" "$empty_chars" "$percentage"
}

run_timer() {
    local TOTAL_S=$1
    local LABEL=$2
    local COLOR=$3
    local i=0

    hide_cursor
    clear 
    
    while [ $i -le $TOTAL_S ]; do
        local CURRENT_COLS=$(tput cols)
        local CURRENT_LINES=$(tput lines)

        REMAINING=$((TOTAL_S - i))
        M=$((REMAINING / 60))
        S=$((REMAINING % 60))
        
        # 1. Box Dimensions
        local box_width=$(( CURRENT_COLS - 2 ))
        local box_height=$(( CURRENT_LINES - 3 ))

        # 2. Manual Vertical Offset
        # We assume content is roughly 7 lines tall. 
        # We subtract 2 for the borders, then subtract 7 for the text.
        local inner_h=$(( box_height - 2 ))
        local padding_val=$(( (inner_h - 7) / 2 ))
        
        # Fallback: If terminal is too small, padding must be at least 0
        [[ $padding_val -lt 0 ]] && padding_val=0

        # Create the spacer string using a simple loop (more compatible than seq)
        local v_spacer=""
        for ((p=0; p<padding_val; p++)); do v_spacer+="\n"; done

        # 3. Build Content (Horizontal alignment + Vertical Spacer)
        # Using printf -v to store the string reliably
        local line_label=$(gum style --foreground "$COLOR" --bold --width "$box_width" --align center "$LABEL")
        local line_cycle=$(gum style --width "$box_width" --align center "Cycle: $CYCLE")
        local line_time=$(gum style --width "$box_width" --align center "$(printf "Time Remaining: %02d:%02d" $M $S)")
        local line_bar=$(gum style --width "$box_width" --align center "$(draw_bar $i $TOTAL_S)")
        local line_hint=$(gum style --faint --width "$box_width" --align center "[p] Pause  [s] Skip  [q] Quit")

        # Combine everything into one variable
        # The %b allows the \n in v_spacer to be interpreted as newlines
        local UI_CONTENT=$(printf "%b%s\n\n%s\n%s\n%s\n\n%s" \
            "$v_spacer" "$line_label" "$line_cycle" "$line_time" "$line_bar" "$line_hint")

        # 4. Render
        printf "\033[H" # Move cursor home
        gum style \
            --border double \
            --border-foreground "$COLOR" \
            --width "$box_width" \
            --height "$box_height" \
            "$UI_CONTENT"
        
        read -s -n 1 -t 1 key
        case "$key" in
            p) clear; gum style --foreground 3 --bold "TIMER PAUSED. Press any key to resume..."; read -s -n 1; clear ;;
            s) return 0 ;;
            q) show_cursor; exit 0 ;;
        esac
        ((i++))
    done
}

prompt_next() {
    local type=$1
    show_cursor
    clear
    gum style --foreground 5 --bold "Session Complete!"
    choice=$(gum choose --cursor.foreground="6" "Start $type" "Skip" "Quit")
    
    case "$choice" in
        "Quit") exit 0 ;;
        "Skip") return 1 ;;
        *) return 0 ;;
    esac
}

while true; do
    ((CYCLE++))
    dunstify -u normal "Pomodoro" "Focus Session Starting"
    run_timer $TIME_FOCUS "FOCUS MODE" "2" 

    if ((CYCLE % 4 == 0)); then
        if prompt_next "Long Break"; then
            run_timer $TIME_LONG_BREAK "LONG BREAK" "4"
        fi
    else
        if prompt_next "Short Break"; then
            run_timer $TIME_SHORT_BREAK "SHORT BREAK" "6"
        fi
    fi
done
