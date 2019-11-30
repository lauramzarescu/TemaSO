#!/bin/bash

function alegere_optiune() {
  if [[ $1 == "1" ]]; then
    insert
    actiune="inserare"
  elif [[ $1 == "2" ]]; then
    delete
    actiune="stergere"
  elif [[ $1 == "3" ]]; then
    cautare
    actiune="cautare"
  elif [[ $1 == "4" ]]; then
    afisare
    actiune="afisare"
  elif [[ $1 == "5" ]]; then
    empty
    actiune="stergere continut"
  elif [[ $1 == "6" ]]; then
    reset
    actiune="resetare"
  elif [[ $1 -lt "1" || $1 -gt "5" ]]; then
    echo "Optiune invalida!"
  fi
}

function update_index() {
  count=`wc -l agenda.txt | awk '{ print $1 }'`
  for ((i=1;i<=$count;i++)); do
    sed -i "$i s/^[^.]*./$i./" agenda.txt
  done
}

function time_log() {
  time_var=`date`
  printf "$time_var"
}

function meniu() {
  # clear
  printf "\n1. Adauga inregistrare\n2. Sterge inregistrare\n3. Cauta\n4. Afisare\n5. Sterge tot continutul\n6. Reset\n"
}

function submeniu() {
  # clear
  printf "\n $log \n\n1. Revenire la meniul principal\n2. Repetati ultima actiune ($1)\n3. Iesire\nCe vreti sa faceti mai departe? [1 | 2 | 3] "
}

function update_log() {
  log_var="$(time_log)   $*"
  echo $log_var >> log.txt
}

function insert() {
  clear
  time_log
  printf "\n"
  echo -n "Nume: "
  read nume
  echo -n "Prenume: "
  read prenume
  echo -n "Telefon: "
  read telefon

  count=`wc -l agenda.txt | awk '{ print $1 }'`
  let "count=count+1"
  res="${count}. ${nume} ${prenume} ${telefon}"

  log="Inserare cu succes!"
  update_log $log

  echo $res >> agenda.txt
}

function delete() {
  clear
  time_log
  printf "\n"
  echo -n "Introduceti datele inregistrarii (index / nume complet / telefon): "
  read sterge
  if grep -Fq "$sterge" agenda.txt; then
    sed -i "/$sterge/d" agenda.txt
    log="Stergere cu succes!"
    update_log $log
    update_index
    afisare
  else
      echo -n "Inregistrarea nu a fost gasita!"
      log="Eroare la stergere!"
  fi
}

function cautare() {
  clear
  time_log
  printf "\n"
  echo -n "Introduceti datele inregistrarii (index / nume complet / telefon): "
  read cauta
  if grep -Fq "$cauta" agenda.txt; then
    grep "$cauta" agenda.txt
    count_cautare=`grep "$cauta" agenda.txt | wc -l`
    log="Au fost gasite $count_cautare rezultate!"
    update_log $log
  else
    echo -n "Inregistrarea nu a fost gasita!"
    log="Eroare la cautare!"
    update_log $log
  fi
}

function empty() {
  clear
  time_log
  printf "\n"
  > agenda.txt
  log="Golire agenda!"
  update_log $log
}

function reset() {
  clear
  time_log
  printf "\n"
  rm agenda.txt
  rm log.txt
  exit 1
}

function afisare() {
  clear
  time_log
  printf "\n"
  count=`wc -l agenda.txt | awk '{ print $1 }'`
  if [[ $count == "0" ]]; then
    log="Nu exista nicio inregistrare"
    update_log $log
  else
    log="Afisare agenda..."
    update_log $log
    cat agenda.txt
  fi
}

FILE=agenda.txt
LOG_FILE=log.txt
if [ test -f "$FILE" ] && [ test -f "$LOG_FILE" ]; then
  count=`wc -l agenda.txt | awk '{ print $1 }'`
else
  touch agenda.txt
  touch log.txt
fi

optiune_submeniu="1"

while [[ $optiune_submeniu != "3" ]]; do
  if [[ $optiune_submeniu == "1" ]]; then
    clear
    meniu
    printf "\nIntroduceti optiunea [1 | 2 | 3 | 4 | 5]: "
    read optiune
    alegere_optiune "$optiune"
  elif [[ $optiune_submeniu == "2" ]]; then
    alegere_optiune "$optiune"
  fi

  submeniu "$actiune"
  read optiune_submeniu

done
