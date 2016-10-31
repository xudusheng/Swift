/**
 * Created by zhengda on 16/10/31.
 */

import * as TYPES from '../actions/types';

const initialState = {
    isRefreshing: false,
    loading: false,
    noMore: false,
    movieList: {},//元素：{dataBlob:{}, sectionIDs:[], rowIDs:[]}
};

export default function movie(state = initialState, action) {
    console.log('reducer = ' + action.typeId, action.movieList);
    switch (action.type) {
        case TYPES.FETCH_DOING:
            return {
                ...state,
                loading: true,
            };

        case TYPES.FETCH_DONE:
            return {
                ...state,
                loading: false,
                movieList: action.isLoadMore ? loadMore(state, action) : combine(state, action),
                noMore:action.movieList.length == 0,
            };

        case TYPES.FETCH_ERROE:
            return {
                ...state,
                loading: false,
            };
        default:
            return state;
    }
};

function loadMore(state, action){
    state.movieList[action.typeId] = action.movieList;
    return state.movieList;
}

function combine(state, action){
    state.articleList[action.typeId] = state.articleList[action.typeId].concat(action.movieList);
    return state.movieList;
}

function resetNoMoreLoadStatus(action) {
    if(action.movieList.length < 1){

    }
}