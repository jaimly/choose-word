<script setup>
import { ref, nextTick } from 'vue';
import { words } from './data.json';

const localData = handlerLocalData();
let arr = localData.length?localData:[...words];
let word = ref('请“开始”');
let btnName = ref('开始');
let wordLen = ref(arr.length);
let btnDisable = ref(false);

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
  handlerLocalData(arr);
  if(!arr.length) {
    btnDisable.value = true;
    word.value = '请“重置”';
  }
}

async function reset () { 
  if(btnName.value === '停止') stop();
  arr = [...words];
  wordLen.value = arr.length;
  word.value = '请“开始”';
  btnDisable.value = false;
  handlerLocalData(arr);
}

function handlerLocalData (data) {
  const key = 'words';
  if(data) return localStorage.setItem(key, JSON.stringify(data));
  const ldata = localStorage.getItem(key);
  if(ldata) return JSON.parse(ldata);
  return [];
}
</script>

<template>
  <main>
    <h1>{{ word }}</h1>
    <div class="foot">
      <button class="startBtn" @click="btnName === '开始' ? choose(true) : stop()" :disabled='btnDisable'>{{ btnName }}</button>
      <div class="reset">
        <p>剩余词数：{{wordLen}}</p>
        <button class="resetBtn"  @click="reset()" >重置</button>
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
    border: none;
    border-radius: 4px;
    color: white;
    font-size: xx-large;
    width: 120px;
    height: 50px;
    font-weight: bold;
    letter-spacing: 5px;
    cursor: pointer;
}

.resetBtn {
  width: 80px;
  height: 40px;
  font-size: large;
  border: none;
  border-radius: 4px;
  letter-spacing: 3px;
  cursor: pointer;
}
</style>