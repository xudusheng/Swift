/**
 * Created by Hmily on 2016/11/27.
 */

import {REQUEST_DOING, REQUEST_DONE, REQUEST_ERROR} from '../../const/GlobalConst'

const initialState = {
    isRefreshing: false,//是否下拉刷新
    loading: false,//是否正在加载
    newsArray: {},
};
export default function news(state = initialState, action) {

    switch (action.type) {
        case REQUEST_DOING:
            return {
                ...state,
                isRefreshing: !action.isLoadMore,
                loading: true,
            };

        case REQUEST_DONE:
            return {
                ...state,
                isRefreshing: false,
                loading: false,
                newsArray: resultData(state, action, action.isLoadMore)
            };

        case REQUEST_ERROR:
            return {
                ...state,
                isRefreshing: false,
                loading: false,
            };
        default:
            return state;
    }
}

function resultData(state, action, isLoadMore) {

    var newsForID = state.newsArray[action.id];
    if (isLoadMore){
        newsForID = newsForID.concat(action.result);
    }else {
        newsForID = action.result;
    }
    state.newsArray[action.id] = newsForID;
    return state.newsArray;
}