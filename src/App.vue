<script setup>
import { ref, nextTick, watch } from 'vue';
import { words } from './data.json';

const localWords = handlerLocalWords();
let arr = localWords.length?localWords:[...words];
let word = ref('请“开始”');
let btnName = ref('开始');
let wordLen = ref(arr.length);
let startBtnDisable = ref(false);
const scores = handlerLocalScores();
let scoreA = ref(scores.scoreA);
let scoreB = ref(scores.scoreB);
let scoreC = ref(scores.scoreC);
let scoreD = ref(scores.scoreD);
let scoreE = ref(scores.scoreE);
const scoreRef = {scoreA,scoreB,scoreC,scoreD,scoreE};
let scoreChecked = ref(scores.checked);

async function choose(start=false) {
  if(start) {
    btnName.value = '停止';
    await nextTick();
  }
  if(btnName.value === '开始') return;
  word.value = arr[Math.floor(Math.random()*arr.length)];
  await nextTick();
  setTimeout(() => {
    choose();
  }, 50);
}

async function stop () {
  btnName.value = '开始';
  await nextTick();
  arr.splice(arr.findIndex(x=>x===word.value), 1);
  wordLen.value = arr.length;
  handlerLocalWords(arr);
  if(!arr.length) {
    startBtnDisable.value = true;
    word.value = '请“重置”';
  }
}

async function reset () { 
  if(btnName.value === '停止') stop();
  arr = [...words];
  wordLen.value = arr.length;
  word.value = '请“开始”';
  startBtnDisable.value = false;
  handlerLocalWords(arr);
}

async function scoreHandle (data) {
  scoreRef[scoreChecked.value].value += Number(data);
  scores[scoreChecked.value] += Number(data);
  handlerLocalScores(scores);
}

watch (scoreChecked, (newValue) => {
  scores.checked = newValue;
  handlerLocalScores(scores);
});

function handlerLocalWords (data) {
  const key = 'words';
  if(data) return localStorage.setItem(key, JSON.stringify(data));
  const ldata = localStorage.getItem(key);
  if(ldata) return JSON.parse(ldata);
  return [];
}

function handlerLocalScores (data) {
  const key = 'wordScores';
  const ldata = localStorage.getItem(key);
  if(!ldata) {
    data = data || {
      checked: 'scoreA',
      scoreA: 0,
      scoreB: 0,
      scoreC: 0,
      scoreD: 0,
      scoreE: 0
    };
  }
  if(data) {
    localStorage.setItem(key, JSON.stringify(data));
    return data;
  }
  return JSON.parse(ldata);
}
</script>

<template>
  <main>
    <div class="score">
      <div>
        <input type="radio" id="scoreA" name="scores" v-model="scoreChecked" value='scoreA' />
        <h2 for="scoreA">A组: <span>{{scoreA}}</span>分</h2>
      </div>
      <div>
        <input type="radio" id="scoreB" name="scores" v-model="scoreChecked" value='scoreB' />
        <h2 for="scoreB">B组: <span>{{scoreB}}</span>分</h2>
      </div>
      <div>
        <input type="radio" id="scoreC" name="scores" v-model="scoreChecked" value='scoreC' />
        <h2 for="scoreC">C组: <span>{{scoreC}}</span>分</h2>
      </div>
      <div>
        <input type="radio" id="scoreD" name="scores" v-model="scoreChecked" value='scoreD' />
        <h2 for="scoreD">D组: <span>{{scoreD}}</span>分</h2>
      </div>
      <div>
        <input type="radio" id="scoreE" name="scores" v-model="scoreChecked" value='scoreE' />
        <h2 for="scoreE">E组: <span>{{scoreE}}</span>分</h2>
      </div>
    </div>
    <h1>{{ word }}</h1>
    <div class="foot">
      <button class="startBtn" @click="btnName === '开始' ? choose(true) : stop()" :disabled='startBtnDisable'>{{ btnName }}</button>
      <div class="scoreBtn" >
        <button @click="scoreHandle(1)">积1分</button>
        <button @click="scoreHandle(-0.5)">扣0.5分</button>
      </div>
      <div class="reset">
        <p>剩余词数: {{wordLen}}</p>
        <button @click="reset()" >重置</button>
      </div>
    </div>
  </main>
</template>

<style scoped>
main {
  display: flex;
  flex-direction: column;
  align-items: center;
  height: inherit;
  justify-content: space-evenly;
  width: 100%;
  height: 100%;
}

.score {
  display: flex;
  flex-direction: row;
  width: 100%;
  justify-content: space-around;
}

.score div {
  display: flex;
  flex-direction: row;
  gap: 3px;
}

.score h2 span {
  color: red;
  font-weight: bold;
}

.foot {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  width: 60%;
  justify-content: space-around;
}
.reset {
  display: flex;
  flex-direction: column;
  align-items: center;
}

h1 {
  font-size: 20vw; 
  user-select: none;
  width: 100%;
  text-align: center;
}

.startBtn {
  background-color: orangered;
  color: white;
  font-size: xx-large;
  width: 120px;
  height: 50px;
  font-weight: bold;
  letter-spacing: 5px;
}

.scoreBtn {
  display: flex;
  flex-direction: row;
  gap: 20px;
}
.scoreBtn button {
  background-color: darkcyan;
  color: white;
  font-size: x-large;
  width: 100px;
  height: 40px;
  font-weight: bold;
  letter-spacing: 0px;
}

.reset button {
  width: 80px;
  height: 40px;
  font-size: large;
  letter-spacing: 3px;
}
</style>