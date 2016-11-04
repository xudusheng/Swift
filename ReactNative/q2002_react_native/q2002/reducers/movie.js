/**
 * Created by zhengda on 16/10/31.
 */

import * as TYPES from '../actions/types';

const initialState = {
    isRefreshing: false,//是否下拉刷新
    loading: false,//是否正在加载
    isLoadMore: false,//是否是上拉加载更多
    noMore: false,//已加载全部
    movieList: {},//元素：{dataBlob:{}, sectionIDs:[], rowIDs:[]}
};

export default function movie(state = initialState, action) {
    console.log('reducer = ' + action.typeId, action.movieList);
    switch (action.type) {
        case TYPES.FETCH_DOING:
            return {
                ...state,
                isRefreshing: action.isRefreshing,
                loading: true,
                isLoadMore: action.isLoadMore,
                noMore: false,
            };

        case TYPES.FETCH_DONE:
            return {
                ...state,
                isRefreshing: false,
                loading: false,
                movieList: action.isLoadMore ? loadMore(state, action) : combine(state, action),
                noMore: action.movieList.length == 0,
            };

        case TYPES.FETCH_ERROE:
            return {
                ...state,
                isRefreshing: false,
                loading: false,
                isLoadMore: false,
            };
        default:
            return state;
    }
};

function loadMore(state, action) {
    var movieData = state.movieList[action.typeId];
    var dataBlob = movieData.dataBlob;
    let sectionIDs = movieData.sectionIDs;
    let rowIDs = movieData.rowIDs;

    // return {dataBlob: dataBlob, sectionIDs: sectionIDs, rowIDs: rowIDs};


    console.log('//////////////////////////////////');
    console.log(movieData);

    if (sectionIDs.length == 1) {//只有单组时才有下拉刷新功能，这里的数据结构有待优化，太不好处理了

        let new_dataBlob = action.movieList.dataBlob;
        let new_sectionIDs = action.movieList.sectionIDs;
        let new_rowIDs = action.movieList.rowIDs[0];

        console.log('//////////////////////////////////');
        console.log(action.movieList);
        let sectionnum = sectionIDs[0];
        var singleSection_RowIDs = rowIDs[0];
        let rowsCount = singleSection_RowIDs.length;
        for (var i = 0; i < new_rowIDs.length; i++) {
            let index = i;
            let new_rowData = new_dataBlob[sectionnum + ':' + index];
            dataBlob[sectionnum + ':' + (rowsCount + index)] = new_rowData;
            singleSection_RowIDs.push(rowsCount + index);
            console.log(index);
        }
        let new_movieList = {dataBlob: dataBlob, sectionIDs: sectionIDs, rowIDs: [singleSection_RowIDs]};
        state.movieList[action.typeId] = new_movieList;

        console.log('//////////////////////////////////');
        console.log(new_movieList);
    }
    return state.movieList;
}

function combine(state, action) {
    state.movieList[action.typeId] = action.movieList;
    return state.movieList;
}
