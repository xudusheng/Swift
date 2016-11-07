/**
 * Created by zhengda on 16/10/31.
 */
var DomParser = require('react-native-html-parser').DOMParser;
import * as TYPES from './types';
import * as GlobleConst from '../pages/p.const';

export function fetchMovieList(typeId = 0, page = 1) {
    var fetchurl = GlobleConst.FetchURL;
    if (typeId > 0) {
        // http://www.q2002.com/type/1/2.html
        fetchurl = fetchurl + 'type/' + typeId + '/' + page + '.html';
    }

    return htmlRequest(fetchurl, typeId, page);
}

export function searchMovieList(key, page = 1) {//搜索  这里规定typeId = -1
    // http://www.q2002.com/search?wd=风花雪月;
    var fetchurl = GlobleConst.FetchURL;
    let searchTypeId = GlobleConst.SearchTypeId;
    fetchurl += ('search?wd=' + key);
    return htmlRequest(fetchurl, searchTypeId, page);//
}

//TODO:网络请求

let htmlRequest = (fetchurl, typeId, page)=> {
    let isLoadMore = (page > 1);
    let isRefreshing = !isLoadMore;

    return ((dispatch)=> {
        dispatch({'type': TYPES.FETCH_DOING, isLoadMore: isLoadMore, isRefreshing: isRefreshing});

        fetch(fetchurl, {
            // method: 'GET'
        })
            .then((response)=> {
                // console.log(response.text());
                return response.text();
            })
            .then((data)=> {
                let result = dealXMLString(typeId, data);
                dispatch({'type': TYPES.FETCH_DONE, typeId: typeId, movieList: result, isLoadMore: isLoadMore});

            })
            .catch((error)=> {
                //登陆失败
                alert(error.message);
                dispatch({'type': TYPES.FETCH_ERROE, error: error});
            });
    });
};

//TODO:XML解析
let dealXMLString = (typeId, data)=> {
    let rooturl = GlobleConst.FetchURL;
    let isHomePage = (typeId == 0);

    var movieList = [];
    data = data.replace(/&raquo;/g, '');
    data = data.replace(/<\/footer><\/div>/g, '<\/footer>');
    data = data.replace(/<\/div><\/ul>/g, '<\/div>');
    console.log('开始解析');
    let doc = new DomParser().parseFromString(data, 'text/html');
    console.log('解析完成');

    //定义一下变量
    var dataBlob = {},
        sectionIDs = [],
        rowIDs = [];

    let movie_sections = doc.querySelect('div[class="row"]');


    for (var section = 0; section < movie_sections.length; section++) {
        let sectionIndex = section;
        let sectionNode = movie_sections[sectionIndex];

        let movie_rows_test = sectionNode.getElementsByClassName('movie-item');

        if (movie_rows_test.length < 1) {
            continue;
        }

        //获取头信息==>即大的分类信息
        let sectionTitle = "";
        let sectionHref = "";
        let sectionSubTitle = "";
        if (isHomePage) {//如果是首页
            let sectionHeaderNode = sectionNode.querySelect('span a[href]')[0];
            sectionTitle = sectionHeaderNode.getAttribute('title');
            sectionHref = sectionHeaderNode.getAttribute('href');
            sectionSubTitle = sectionHeaderNode.firstChild.nodeValue;
        } else {//其他分类（电影，电视，动漫等）
            sectionTitle = "";
            sectionHref = "";
            sectionSubTitle = "";
        }

        let sectionInfo = {
            sectionTitle: sectionTitle,
            sectionSubTitle: sectionSubTitle,
            sectionHref: rooturl + sectionHref
        };

        //1、把组号放入sectionIDs数组中
        sectionIDs.push(sectionIndex);

        //2、把表头数据放入sectionInfo中
        dataBlob[sectionIndex] = sectionInfo;

        let movie_rows = sectionNode.getElementsByClassName('movie-item');

        var rowIdsInCurrentSection = [];

        for (var row = 0; row < movie_rows.length; row++) {
            let rowIndex = row;
            let rowElement = movie_rows[rowIndex];

            let aNode = rowElement.querySelect('a[href]')[0];
            let imageNode = aNode.querySelect('img')[0];
            let buttonNode = aNode.querySelect('button[class="hdtag"]')[0];
            let updateNode = rowElement.querySelect('span')[0];

            let title = aNode.getAttribute('title');
            let href = rooturl + aNode.getAttribute('href');
            let imageurl = imageNode.getAttribute('src');
            let updateDate = updateNode.firstChild.nodeValue;
            let markTitle = buttonNode.firstChild.nodeValue;

            let oneItemInfo = {
                title: title,
                href: href,
                imageurl: imageurl,
                updateDate: updateDate,
                markTitle: markTitle
            };

            //把行号放入rowIdsInCurrentSection
            rowIdsInCurrentSection.push(rowIndex);
            dataBlob[sectionIndex + ':' + rowIndex] = oneItemInfo;

            movieList.push(oneItemInfo);
        }
        rowIDs.push(rowIdsInCurrentSection);
    }


    // let container_divs = doc.getElementsByClassName('container');
    // if (container_divs.length > 0) {
    //     let containerEl = container_divs[container_divs.length - 1];
    //     var div_Els = null;
    //     console.log('==============================');
    //     console.log(containerEl);
    //
    //     var containerEl_childNodes = containerEl.childNodes;
    //
    //     var divList = [];
    //     for (var nodeIndex = 0; nodeIndex = containerEl_childNodes.length; nodeIndex++) {
    //         let oneChildNode = containerEl_childNodes[nodeIndex];
    //         console.log(oneChildNode);
    //         // if (oneChildNode.hasAttributes()) {
    //         //     divList.push(oneChildNode);
    //         // }
    //     }
    //
    //     console.log(divList);
    //
    // }

    return {dataBlob: dataBlob, sectionIDs: sectionIDs, rowIDs: rowIDs};
};